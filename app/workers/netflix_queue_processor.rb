class NetflixQueueProcessor
  @queue = :processors

  def self.clean(str)
    str.chars.select{|i| i.valid_encoding?}.join
  end

  def self.perform(user_id)
    @user = User.find(user_id)

    client = Netflix::Client.new(@user.netflix_token, @user.netflix_secret)
    netflix_user = client.user(@user.netflix_user_id)

    queue = netflix_user.instant_disc_queue(:include => ['synopsis'])

    old_suggestions = @user.content_items.where(content_provider: 'netflix').pluck(:content_id)

    suggestions = []
    all_ratings = []
    all_times   = []

    # build suggestions here
    queue.discs.each do |disc|

      # obviously this is dirty...
      map = disc.send(:instance_variable_get, :@map)
      disc_id = disc.id.split('/').last

      if content_items = @user.content_items.where(content_id: disc_id).first
        content_items.title = self.clean(disc.title.to_s)
        content_items.description = self.clean(map["link"].select{|l|l["synopsis"]}.first["synopsis"].to_s)
        content_items.image = map["box_art"]["large"]
        content_items.rating = disc.average_rating.to_s
        content_items.position = disc.position.to_s
        if content_items.changed?
          puts "changed, saving"
          content_items.save
        end
      else
       debugger

        puts "new content, creating"
        ContentItem.create({
          user_id:          @user.id,
          content_type:     'video',
          content_provider: 'netflix',
          content_id:       disc_id,
          title:            self.clean(disc.title.to_s),
          description:      self.clean(map["link"].select{|l|l["synopsis"]}.first["synopsis"].to_s),
          image:            map["box_art"]["large"],
          rating:           disc.average_rating,
          position:         disc.position,
        })
      end

      old_suggestions = old_suggestions - [disc_id]

      all_ratings << disc.average_rating
      all_times   << disc.updated
    end

    # any suggestions no longer on the queue have been watched or removed.
    old_suggestions.each do |old_suggestion_content_id|
      puts "old content, marking"
      content_item = ContentItem.where(user_id: @user.id).where(content_id: old_suggestion_content_id).first
      suggestion = SuggestionTrack.where(user_id: @user.id).where(content_item_id: content_item.id).last
      if suggestion
        suggestion.status = 'removed'
        suggestion.save
      end
    end

    # and update user!
    @user.netflix_status = "processed"
    @user.save
  end
end
class NetflixQueueProcessor
  @queue = :processors

  def self.perform(user_id)
    @user = User.find(user_id)

    client = Netflix::Client.new(@user.netflix_token, @user.netflix_secret)
    netflix_user = client.user(@user.netflix_user_id)

    queue = netflix_user.instant_disc_queue(:include => ['synopsis'])

    old_suggestions = @user.content_suggestions.where(content_provider: 'netflix').pluck(:content_id)

    suggestions = []
    all_ratings = []
    all_times   = []

    # build suggestions here
    queue.discs.each do |disc|

      # obviously this is dirty...
      map = disc.send(:instance_variable_get, :@map)

      if suggestion = ContentSuggestion.find_by_content_id(disc.id)
        suggestion.attributes({
          title:            disc.title,
          description:      map["link"].select{|l|l["synopsis"]}.first["synopsis"],
          image:            map["box_art"]["large"],
          rating:           disc.average_rating,
          position:         disc.position,
        })
        if suggestion.changed?
          puts "changed, saving"
          suggestion.save
        end
      else
        puts "new content, creating"
        ContentSuggestion.create({
          user_id:          @user.id,
          content_type:     'video',
          content_provider: 'netflix',
          content_id:       disc.id,
          title:            disc.title,
          description:      map["link"].select{|l|l["synopsis"]}.first["synopsis"],
          image:            map["box_art"]["large"],
          rating:           disc.average_rating,
          position:         disc.position,
        })
      end

      old_suggestions = old_suggestions - [disc.id]

      all_ratings << disc.average_rating
      all_times   << disc.updated
    end

    # any suggestions no longer on the queue have been watched or removed.
    old_suggestions.each do |old_suggestion_content_id|
      puts "old content, marking"
      suggested = ContentSuggestion.where(user_id: @user.id).where(content_id: old_suggestion_content_id).first
      suggested.status = 'removed'
      suggested.save
    end

    # Going to disable this for now...
    # get some stats
    # stddev_ratings = all_ratings.to_scale.sd
    # mean_ratings = all_ratings.to_scale.mean
    # stddev_times = all_times.to_scale.sd
    # mean_times = all_times.to_scale.mean

    # great, so let's rank

    # and save!
    @user.netflix_status = "processed"
    @user.save

  end
end
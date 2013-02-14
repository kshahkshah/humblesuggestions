class NetflixQueueProcessor
  @queue = :processors

  def self.perform(user_id)
    @user = User.find(user_id)

    client = Netflix::Client.new(@user.netflix_token, @user.netflix_secret)
    netflix_user = client.user(@user.netflix_user_id)

    queue = netflix_user.instant_disc_queue

    # process each movie within here..
    queues.discs.each do |movie|

    end

  end
end
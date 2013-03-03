class UpdateQueues
  @queue = :processors

  def self.perform
    User.all.each do |user|
      Resque.enqueue(NetflixQueueProcessor, user.id) if user.netflix_connected?
      # and future processors here or programatically...
    end
  end
end
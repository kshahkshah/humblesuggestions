class EmailDispatcher
  @queue = :mail

  def self.perform
    User.all.each do |user|
      UserMailer.daily_suggestion(user).deliver
    end
  end
end
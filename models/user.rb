class User < ActiveRecord::Base

  def image_url(size = 24)
    gravatar_url = 'https://secure.gravatar.com'
    default_image_url = 'https://a248.e.akamai.net/assets.github.com/images/gravatars/gravatar-140.png'
    url = "#{gravatar_url}/avatar/#{gravatar_id}?s=#{size.to_s}&d=#{default_image_url}"
  end

  def profile_url
    "https://github.com/#{username}"
  end

  def self.find_or_create_by_auth_hash(auth_hash)
    find_by_uid(auth_hash['id'].to_s) || create_from_auth_hash(auth_hash)
  end

  def explored!(route)
    $redis.sadd(redis_key(:explored), route.id)
  end

  def explorations
    explored_ids = $redis.smembers(redis_key(:explored))
    Route.where(id: explored_ids)
  end

  def explored?(route)
    $redis.sismember(redis_key(:explored), route.id)
  end

  def explored_count
    $redis.scard(redis_key(:explored))
  end

  private

  def self.create_from_auth_hash(auth_hash)
    create! do |u|
      u.uid         = auth_hash['id']
      u.username    = auth_hash['login']
      u.gravatar_id = auth_hash['gravatar_id']
    end
  end

  def redis_key(str)
    "explorer:user:#{id}:#{str}"
  end
end

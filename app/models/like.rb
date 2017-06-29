class Like
  @headers = {}
  @headers["content-type"] = "application/json"
  @headers["User-agent"] = "Tinder/4.7.1 (iPhone; iOS 9.2; Scale/2.00)"
  def self.get_token()
    id = JSON.parse(`python config.py`)["fb_id"]
    token = JSON.parse(`python config.py`)["token"]
    tinder_token = JSON.parse(RestClient.post('https://api.gotinder.com/auth', {'facebook_token': token, 'facebook_id': id}.to_json, @headers))["token"]
    tinder_token
  end

  def self.like(id, token)
    @headers['X-Auth-Token'] = token
    JSON.parse(RestClient.get("https://api.gotinder.com/like/#{id}", @headers))
  end

  def self.get_recommendations(token)
    @headers['X-Auth-Token'] = token
    return JSON.parse(RestClient.get("https://api.gotinder.com/user/recs", @headers))
  end

  def self.like_all(token, number)
    number_liked = 0
    recommendations = Like.get_recommendations(token)
    if recommendations.key?("results")
      recs = recommendations["results"]
      number_liked = number_liked + recs.length
      while number_liked < number
        recs.each do |rec|
          Like.like(rec["_id"], token)
          puts "liked #{rec["name"]}"
        end
        recommendations = Like.get_recommendations(token)
        if recommendations.key?("results")
          recs = recommendations["results"]
          number_liked = number_liked + recs.length
        elsif recommendations["message"] == "recs exhausted" || recommendations["message"] == "recs timeout"
          recs = []
          profile = Like.get_self(token)
          Like.increase_distance(token, profile["distance_filter"])
        end
      end
    elsif
      profile = Like.get_self(token)
      Like.increase_distance(profile["distance_filter"])
      Like.like_all(token, number)
    end
    return number_liked
  end

  def self.get_self(token)
    @headers['X-Auth-Token'] = token
    return JSON.parse(RestClient.get("https://api.gotinder.com/profile", @headers))
  end

  def self.increase_distance(token, distance)
    @headers['X-Auth-Token'] = token
    return JSON.parse(RestClient.post("https://api.gotinder.com/profile",{"distance_filter": (distance + 10)}, @headers))
  end
end

module ApplicationHelper
    def avatar_url_for(user, size: 128)
        name = user.username || user.email.split('@').first
        "https://ui-avatars.com/api/?name=#{ERB::Util.url_encode(name)}&background=6b46c1&color=fff&size=#{size}"
      end
      
end

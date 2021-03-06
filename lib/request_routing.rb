module ActionController
  module Routing
    class Route
      
      TESTABLE_REQUEST_METHODS = [:subdomain, :full_subdomain, :domain, :method, :port, 
                                  :remote_ip, :content_type, :accepts, :request_uri, :protocol]
      
      def recognition_conditions
        result = ["(match = #{Regexp.new(recognition_pattern).inspect}.match(path))"]
        conditions.each do |method, value|
          if TESTABLE_REQUEST_METHODS.include? method
            result << if value.is_a? Regexp
              "conditions[#{method.inspect}] =~ env[#{method.inspect}]"
            elsif value.is_a? Array # :subdomain => [false, 'signup', 'chinchilla']
              "(conditions[#{method.inspect}].first == conditions[#{method.inspect}].include?(env[#{method.inspect}]))"
            else
              "conditions[#{method.inspect}] === env[#{method.inspect}]"
            end
          else
          end
        end
        result
      end
      
    end
    
    class RouteSet
      
      def extract_request_environment(request)
        { 
          :method => request.method,
          :subdomain => request.subdomains.first.to_s, 
          :full_subdomain => request.subdomains.join('.').to_s, 
          :domain => request.domain, 
          :port => request.port, 
          :remote_ip => request.remote_ip, 
          :content_type => request.content_type, 
          :accepts => request.accepts.map(&:to_s).join(','), 
          :request_uri => request.request_uri, 
          :protocol => request.protocol
        }
      end
      
    end
  end
end
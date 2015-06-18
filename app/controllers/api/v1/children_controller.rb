class Api::V1::ChildrenController<Api::BaseController
	respond_to :json	
	before_action :auth_user

	def index
		if @user_parent
			p 'This is parent'
			user = current_user
			if params[:token_for_device] != ""
				@current_device_token = params[:token_for_device]
				user.device_token = @current_device_token
				user.update_attributes(device_token: @current_device_token)
			end			
			@children = Child.all	
			p "#{user.device_token}"
			render json: @children, status: 200	  	
		end		
	end

	def show_all
		@all_play_networks = PlayNetwork.all
		render json: @all_play_networks, status: 200         
	end
# Send Notifications to device
	def send_invite_notification
		if @user_parent
			p 'This is parent'
			user = current_user			

	        if params[:invited_child_id]
          		invited_child_id = params[:invited_child_id]
				p "#{invited_child_id}"
				invited_user = User.find_by_id(Parent.find_by_family_id(Child.find_by_mac_address(invited_child_id).family_id).user_id)
				invited_token = invited_user.device_token
				
				end_timestamp = params[:end_time]
				invited_child_name = Child.find_by_mac_address(invited_child_id).name
				invited_device_id = Child.find_by_mac_address(invited_child_id).playcelet
				host_color = params[:color]

				gcm = GCM.new("AIzaSyCkvQ6Ea4z_66VbDFTHVEA3OGn_Z82wtlE")
		        @notify_token = invited_token
		        registration_ids = [@notify_token];
		        options =
		        {
		          data:
		          {
		            msg: "New invitation to #{invited_child_name}",
		            invited_child_name: invited_child_name,
		            invited_child_playcelet_id: invited_device_id,
		            invited_child_playcelet_address: invited_child_id,
		            end_timestamp: end_timestamp,
		            host_color: host_color,
		            condition: 1,
		          }
		        }

		        response = gcm.send_notification(registration_ids,options)
        	elsif params[:invited_child_ids]
        		params[:invited_child_ids].split(',').each do |mac_address|
        			invited_user = User.find_by_id(Parent.find_by_family_id(Child.find_by_mac_address(mac_address).family_id).user_id)
        			invited_token = invited_user.device_token
        			if invited_token.blank?
						return        				
        			else
						end_timestamp = params[:end_time]
						invited_child_name = Child.find_by_mac_address(mac_address).name
						invited_device_id = Child.find_by_mac_address(mac_address).playcelet

						host_color = params[:color]

						gcm = GCM.new("AIzaSyCkvQ6Ea4z_66VbDFTHVEA3OGn_Z82wtlE")
				        @notify_token = invited_token
				        registration_ids = [@notify_token];
				        options =
				        {
				          data:
				          {
				            msg: "New invitation to #{invited_child_name}",
				            invited_child_name: invited_child_name,
				            invited_child_playcelet_id: invited_device_id,
				            invited_child_playcelet_address: mac_address,
				            end_timestamp: end_timestamp,
				            host_color: host_color,
				            condition: 1,
				          }
				        }
				        response = gcm.send_notification(registration_ids,options)
				    end
	        	end
        	end
	        # puts response
			# render json: @children, status: 200	  	
		end		
	end
	def send_rsvp_notification
		if @user_parent
			p 'This is parent'
			user = current_user
			invite_user_id = params[:invite_user_id]
			invite_user = User.find_by_id(Parent.find_by_id(invite_user_id).user_id)
			invite_token = invite_user.device_token
			
			invitation_id = params[:invitation_id]

			status = params[:status]
			child_name = params[:child_name]
			child_color = params[:color]
			child_playcelet = params[:playcelet_id]
			invited_playcelet_mac = params[:invited_device_id]

			p "#{invited_playcelet_mac}"
			invited_playcelet_id = Child.find_by_mac_address(invited_playcelet_mac).playcelet

			end_timestamp = params[:end_time]

			child_id = Child.find_by_first_name(child_name).id
			child_full_name = Child.find_by_first_name(child_name).name
			child_playcelet_id = Child.find_by_first_name(child_name).playcelet

			gcm = GCM.new("AIzaSyCkvQ6Ea4z_66VbDFTHVEA3OGn_Z82wtlE")
	        @notify_token = invite_token
	        registration_ids = [@notify_token];
	        p "#{@notify_token}"
	        p "#{invitation_id}"
	        message = "#{child_name} #{status} your invitation."
	        options =
	        {
	          data:
	          {
	            msg: message,
	            status: status,
	            invitation_id: invitation_id,
	            child_id: child_id,
	            child_full_name: child_full_name,
	            child_color: child_color,
	            child_playcelet: child_playcelet,
	            child_playcelet_id: child_playcelet_id,
	            invited_playcelet_id: invited_playcelet_id,
	            invited_playcelet_address: invited_playcelet_mac,
	            end_timestamp: end_timestamp,
	            condition: 2,
	          }
	        }

	        response = gcm.send_notification(registration_ids,options)
	        # puts response
			# render json: @children, status: 200	  	
		end		
	end
	def check_in_notification
		if @user_parent
			p 'This is parent'
			user = current_user
			parent_id = params[:parent_id]
			parent = User.find_by_id(Parent.find_by_id(parent_id).user_id)
			parent_token = parent.device_token
			
			child_name = params[:child_name]
			supervisor_name = params[:supervisor_name]

			gcm = GCM.new("AIzaSyCkvQ6Ea4z_66VbDFTHVEA3OGn_Z82wtlE")
	        @notify_token = parent_token
	        registration_ids = [@notify_token];
	        options =
	        {
	          data:
	          {
	            msg: "#{child_name} is with #{supervisor_name}",
	            child_name: child_name,
	            parent_name: supervisor_name,
	            condition: 3,
	          }
	        }

	        response = gcm.send_notification(registration_ids,options)
	        # puts response
			# render json: @children, status: 200	  	
		end		
	end
	def come_home_notification
		if @user_parent
			p 'This is parent'
			user = current_user
			invited_parent_id = params[:invited_parent_id]
			invited_parent = User.find_by_id(Parent.find_by_id(invited_parent_id).user_id)     
			invited_parent_token = invited_parent.device_token
			
			child_name = params[:child_name]

			gcm = GCM.new("AIzaSyCkvQ6Ea4z_66VbDFTHVEA3OGn_Z82wtlE")
	        @notify_token = parent_token
	        registration_ids = [@notify_token];
	        options =
	        {
	          data:
	          {
	            msg: "It's time to #{child_name} come home",
	            condition: 4,
	          }
	        }

	        response = gcm.send_notification(registration_ids,options)
	        # puts response
			# render json: @children, status: 200	  	
		end		
	end
	def overdue_home_notification
		if @user_parent
			p 'This is parent'
			user = current_user
			invite_parent_id = params[:invite_parent_id]
			invite_parent = User.find_by_id(Parent.find_by_id(invite_parent_id).user_id)
			invite_parent_token = invite_parent.device_token			
			
			child_name = params[:child_name]

			gcm = GCM.new("AIzaSyCkvQ6Ea4z_66VbDFTHVEA3OGn_Z82wtlE")
	        @notify_token = parent_token
	        registration_ids = [@notify_token];
	        options =
	        {
	          data:
	          {
	            msg: "Overdue come home.#{child_name}",
	            condition: 5,
	          }
	        }

	        response = gcm.send_notification(registration_ids,options)
	        # puts response
			# render json: @children, status: 200	  	
		end		
	end
end
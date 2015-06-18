class PlayceletDataCleaner
	PLAYCELET_DATA_CLASSES = [
		EventLog,
		DelayedJob,
		PlayInvitation,
		Info,
		Message
	]
	class << self
		def clear_all
			PLAYCELET_DATA_CLASSES.each do |playcelet_data_class|
				playcelet_data_class.destroy_all
			end
			Child.all.update_all(app_id: nil)
		end

		def clear1DaysData
			records_age_options = ['created_at <= ?', 1.days.ago.utc]
			PLAYCELET_DATA_CLASSES.each do |playcelet_data_class|
				playcelet_data_class.destroy_all(records_age_options)
			end
			EventLog.clear1DaysData
		end
	end
end
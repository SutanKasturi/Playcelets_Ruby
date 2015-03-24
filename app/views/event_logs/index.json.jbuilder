json.array!(@event_logs) do |event_log|
  json.extract! event_log, :id, :event_type, :record_type, :record_id, :initiator_type, :initiator_id, :family1_id, :family2_id, :parent1_id, :parent2_id, :child1_id, :child2_id
  json.url event_log_url(event_log, format: :json)
end

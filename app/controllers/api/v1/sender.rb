require 'gcm'

gcm = GCM.new("AIzaSyCkvQ6Ea4z_66VbDFTHVEA3OGn_Z82wtlE")
registration_ids = ["APA91bG3YnhNijHzBT52oOp6oe2ROFpJdyWLP43RKlLof8phHBHGcv1s1dUlFNyx60k3C6hP6MHhhsEGHpjpnXbvF5lhXv8fM1UwCOz0bCJ7Y3Vu__CvyN9i7Zv4MM1rG4qrwuOUzc79JueRKBYFqM_oYoKjZIBZPA","APA91bF3_fNf1PmjmR2PqP-MFw6ocTCaoanTFasWYBMvzngFanA59IX6iw20HqUL96H935KhEeW90CgnuKyLBcCH-FV1fyyLAYsLrcbJ9uQHCNuB3o5BhEMFRDu0ub4wH_0LGvkskIdWUikhsQvNx7vMmIKKPZ_E8g"];
options = {data: {msg: "Notification test from Ruby server!"}}
response = gcm.send_notification(registration_ids, options)

puts response
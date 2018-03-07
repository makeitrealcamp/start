class ChangeStatusApplicationActivity < ApplicantActivity
  hstore_accessor :info,
  current_status: :string,
  past_status:    :string
end

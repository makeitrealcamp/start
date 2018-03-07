class EmailApplicationActivity < ApplicantActivity
  hstore_accessor :info,
  subject:        :string,
  body:           :string
end

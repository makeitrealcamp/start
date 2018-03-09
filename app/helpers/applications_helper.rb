module ApplicationsHelper 

  def count_application_status(status)
    #Through reduce a new hash of hashes containing the status and its number of ocurrences is created
    status_count = TopApplicant.statuses.reduce ({}) do|accu, status|
      accu.merge({status[0]=>0})
    end
    TopApplicant.all.each do|topApplicant|
      status_count.each do |status|
        if topApplicant.status == status[0]
          status_count["#{topApplicant.status}"]+=1
        end
      end
    end 
    status_count["#{status}"]
  end
end

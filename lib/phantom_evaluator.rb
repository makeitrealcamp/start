# encoding: UTF-8
class PhantomEvaluator
  def evaluate(solution)
    host = ENV['HOSTNAME'] || "http://localhost:3000"
    filename = 'tmp/eval-' + solution.id.to_s + '.js'
    File.open(filename, 'w') do |f|
      f.write "function open(path, callback) {"
      f.write "  var page = require('webpage').create();"
      f.write "  page.viewportSize = { width: 1024, height: 800 };"
      f.write "  var url = '#{host}/solutions/#{solution.id}/preview/' + path;"
      f.write "  page.open(url, function(status) {"
      f.write "    if (status != 'success') {"
      f.write "      console.log('No se pudo abrir ' + path);"
      f.write "      return;"
      f.write "    }"
      f.write "    page.injectJs('lib/phantom-util.js');"
      f.write "    var result = page.evaluate(callback);"
      f.write "    if (result) { console.log(result); }"
      f.write "    phantom.exit();"
      f.write "  });"
      f.write "}"
      f.write solution.challenge.evaluation
    end

    output = Phantomjs.run(filename)
    if output.blank?
      solution.status = :completed
      solution.completed_at = DateTime.current
    else
      solution.status = :failed
      solution.error_message = output
    end
    solution.save!

  rescue Exception => e
    puts e.message
    puts e.backtrace

    solution.status = "Failed"
    solution.error_message = "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}"
    solution.save!
  end
end
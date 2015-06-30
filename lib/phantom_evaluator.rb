# encoding: UTF-8
class PhantomEvaluator < Evaluator
  def evaluate(solution)
    host = ENV['HOSTNAME'] || "http://localhost:3000"
    filename = 'tmp/eval-' + solution.id.to_s + '.js'

    script = %Q[var evaluations = [];
var page = require('webpage').create();

function open(path, callback, viewportSize, setup) {
  evaluations.push({ path: path, callback: callback, viewportSize: viewportSize, setup: setup });
}

function evaluate(index) {
  if (index >= evaluations.length) {
    phantom.exit();
  }

  var evaluation = evaluations[index];
  page.viewportSize = evaluation.viewportSize || { width: 1024, height: 800 };
  var url = '#{host}/solutions/#{solution.id}/preview/' + evaluation.path;
  page.open(url, function(status) {
    if (status != 'success') {
      console.log('No se pudo abrir ' + evaluation.path);
      return;
    }

    if (evaluation.setup) {
      evaluation.setup(page);
    }

    page.injectJs('lib/phantom-util.js');
    var result = page.evaluate(evaluation.callback);
    if (result) { 
      console.log(result);
      phantom.exit();
    } else {
      setTimeout(function() { evaluate(index + 1) }, 100);
    }
  });
}
    ]

    File.open(filename, 'w') do |f|
      f.write script + "\n"
      f.write solution.challenge.evaluation + "\n"
      f.write "evaluate(0);"
    end

    output = Phantomjs.run(filename)
    output.blank? ? complete(solution) : fail(solution, output)

  rescue Exception => e
    puts e.message
    puts e.backtrace

    fail(solution, "Hemos encontrado un error en el evaluador, favor reportar a info@makeitreal.camp: #{e.message}")
  end
end
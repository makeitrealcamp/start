class DashboardView
  constructor: ->
    @generate_chart()

  generate_chart: ->
    CanvasJS.addColorSet('mir', ["#ff3300"])
    new CanvasJS.Chart('progress-chart',
      colorSet: "mir",
      data: [
        type: "area",
        dataPoints: eval($('#progress-chart').data('chart'))
      ]
    ).render()

window.DashboardView = DashboardView
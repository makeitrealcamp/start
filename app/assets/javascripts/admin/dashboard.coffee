class AdminDashboardView
  constructor: ->
    @generate_charts()
  generate_charts: ->
    CanvasJS.addColorSet('mir', ["#ff3300"])
    new CanvasJS.Chart('progress-chart-past-months',
      colorSet: "mir",
      data: [
        type: "column",
        dataPoints: eval($('#progress-chart-past-months').data('chart'))
      ]
    ).render()

    new CanvasJS.Chart('progress-chart-present-month',
      colorSet: "mir",

      axisY: 
        includeZero: false
      axisX:
        interval:3
        intervalType: "day" 
        valueFormatString: "MMM DD",
      data: [
        type: "area",
        dataPoints: eval($('#progress-chart-present-month').data('chart'))
      ]
    ).render()

window.AdminDashboardView = AdminDashboardView
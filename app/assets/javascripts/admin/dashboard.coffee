class AdminDashboardView
  constructor: ->
    @generate_charts()

  generate_charts: ->
    new CanvasJS.Chart('registered-users-chart',
      data: [
        type: "column",
        dataPoints: $('#registered-users-chart').data('chart')
      ]
    ).render()

    new CanvasJS.Chart('solved-challenges-chart',
      data: [
        type: "column",
        dataPoints: $('#solved-challenges-chart').data('chart')
      ]
    ).render()

window.AdminDashboardView = AdminDashboardView
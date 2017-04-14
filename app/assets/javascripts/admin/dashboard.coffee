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

    data = eval($('#month-acc').data('chart'))
    data2 = eval($('#month-acc').data('chart2'))
    new CanvasJS.Chart('month-acc', {
      colorSet: "mir"
      creditText: ""
      axisY: { includeZero: false }
      data: [{
        type: "area"
        showInLegend: true
        name: "Mes Anterior"
        color: "rgba(48, 48, 48, .6)"
        dataPoints: data2.map((point) ->
          { y: parseFloat(point['points']), label: point['date'] }
        )
      }, {
        type: "area"
        showInLegend: true,
        name: "Mes Actual"
        dataPoints: data.map((point) ->
          { y: parseFloat(point['points']), label: point['date'] }
        )
      }]
    }).render()

window.AdminDashboardView = AdminDashboardView
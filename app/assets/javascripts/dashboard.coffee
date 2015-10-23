class DashboardView
  constructor: ->
    @generate_chart()

  generate_chart: ->
    CanvasJS.addColorSet('mir', ["#ff3300", "#e5e3e3"])
    new CanvasJS.Chart('progress-chart',
      colorSet: "mir",
      data: [
        type: "area",
        dataPoints: [
          { x: new Date(2012, 6, 15), y: 0, indexLabel: "¡Empezaste!", indexLabelOrientation: "vertical", indexLabelFontColor: "orangered", markerColor: "orangered"},       
          { x: new Date(2012, 6, 18), y: 120 }, 
          { x: new Date(2012, 6, 23), y: 840 }, 
          { x: new Date(2012, 7, 1), y: 1200, indexLabel:"Teclado Amarillo", markerColor: "black" }, 
          { x: new Date(2012, 7, 11), y: 1850 }, 
          { x: new Date(2012, 7, 23), y: 1850 }, 
          { x: new Date(2012, 7, 31), y: 1850 }, 
          { x: new Date(2012, 8, 4), y: 2560, indexLabel:"Teclado Naranja" },
          { x: new Date(2012, 8, 10), y: 2560 },
          { x: new Date(2012, 8, 13), y: 2800 }, 
          { x: new Date(2012, 8, 16), y: 3950 }, 
          { x: new Date(2012, 8, 18), y: 4200, indexLabel:"Teclado Azul" },  
          { x: new Date(2012, 8, 21), y: 4200 }, 
          { x: new Date(2012, 8, 24), y: 4200 }, 
          { x: new Date(2012, 8, 26), y: 4200 }, 
          { x: new Date(2012, 8, 28), y: 4200 } 
        ]
      ]
    ).render()

window.DashboardView = DashboardView
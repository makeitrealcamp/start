class AddLevelsToDataBase < ActiveRecord::Migration
  def change
    Level.create [
      {required_points: 0 ,name: "Teclado Blanco"},
      {required_points: 1000 ,name: "Teclado Amarillo"},
      {required_points: 3000 ,name: "Teclado Naranja"},

      {required_points: 6000 ,name: "Teclado Verde"},
      {required_points: 9500 ,name: "Teclado Azul"},
      {required_points: 13000 ,name: "Teclado Purpura"},

      {required_points: 16500 ,name: "Teclado Café"},
      {required_points: 21000 ,name: "Teclado Rojo"},
      {required_points: 26000 ,name: "Teclado Negro"}
    ]
  end
end

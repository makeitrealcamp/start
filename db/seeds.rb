intro = Course.create(name: "Una nueva mentalidad", time_estimate: "2 horas", row_position: 1, published: true,
  description: "Para poder aprender cualquier habilidad, primero debemos cambiar nuestra mentalidad. La barrera no es intelectual, es emocional.",
  excerpt: "Aprender a programar es difícil. Difícil como aprender un nuevo idioma o un instrumento. Se requiere práctica y paciencia.")

html = Course.create(name: "HTML y CSS", time_estimate: "40 horas", row_position: 2, published: true,
  description: "Aprende el lenguaje de marcado que define la estructura de las páginas Web, y el lenguaje de estilos que les da formato.",
  excerpt: "**HTML** es un lenguaje que nos permite definir **la estructura** de las páginas Web. **CSS** es un lenguaje que nos permite definir **el formato (los estilos)** de los elementos HTML.")

ruby = Course.create(name: "Ruby básico", time_estimate: "58 horas", row_position: 3, published: true,
  description: "Aprende las bases de este lenguaje de programación que es usado para crear aplicaciones Web como Twitter, Groupon, o Make it Real Start.",
  excerpt: "Ruby es un lenguaje de programación flexible y expresivo, ideal para principiantes que quieren aprender a programar.")

Resource.create(course: html, title: "General Assembly - Dash", time_estimate: "4 horas", url: "https://dash.generalassemb.ly/", row_position: 1, published: true,
  description: "Abre una cuenta y crea un landing page usando HTML y CSS. Completa los proyectos: 1. Build a Personal Website y 2. Build a Responsive Blog Theme)")

Resource.create(course: html, title: "W3Schools - HTML", time_estimate: "2 horas", url: "http://www.w3schools.com/html/html_intro.asp", row_position: 2, published: true,
  description: "Un recurso puntual y claro. A veces un poco difícil de navegar por la publicidad. Ha sido criticado porque, a pesar de su nombre, no tiene afiliación con la W3C (la entidad encargada de definir los estándares de la Web).")

Resource.create(course: html, title: "W3Schools - CSS", time_estimate: "2 horas", url: "http://www.w3schools.com/css/css_intro.asp", row_position: 3, published: true,
  description: "Un recurso puntual y claro. A veces un poco difícil de navegar por la publicidad. Ha sido criticado porque, a pesar de su nombre, no tiene afiliación con la W3C (la entidad encargada de definir los estándares de la Web).")

Resource.create(course: html, title: "Codecademy - HTML & CSS", time_estimate: "7 horas", url: "http://www.codecademy.com/tracks/web", row_position: 4, published: true,
  description: "Refuerza tus conocimientos de HTML y CSS con este tutorial interactivo.")

c1 = Challenge.create(course: html, name: "Hola Mundo", row_position: 1, published: true,
  instructions: "Estas son las instrucciones del challenge.", evaluation: "def evaluate(files); end")
Document.create(folder: c1, name: "index.html", content: "")

c2 = Challenge.create(course: html, name: "Ordenando el desorden", row_position: 1, published: false,
  instructions: "Estas son las instrucciones del challenge.", evaluation: "def evaluate(files); return 'Siempre mal'; end")
Document.create(folder: c2, name: "index.html", content: "")

User.create(email: "admin@makeitreal.camp", account_type: User.account_types[:admin_account])

User.create(email: "user_free@makeitreal.camp",account_type: User.account_types[:free_account])

User.create(email: "user_paid@makeitreal.camp",account_type: User.account_types[:paid_account])

Path.create(id: 1, name: "Full-Stack", description: "Conviértete en un desarrollador Full-Stack.", published: true)

Phase.create( name: "Programador Aprendiz", description: "Aprende los conceptos básicos del desarrollo web.", slug: "programador-aprendiz", published: true, color: "#3590BE", path_id: 1)

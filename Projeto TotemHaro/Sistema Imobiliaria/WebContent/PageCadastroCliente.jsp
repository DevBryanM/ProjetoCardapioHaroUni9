<html>
<head>
	<meta charset="utf-8"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<title>Cadastro de Cliente</title>
	 <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #ff416c;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        a {
            text-decoration: none;
            color: #007BFF;
            font-size: 14px;
        }

        a:hover {
            text-decoration: underline;
        }

        .form-container {
            background-color: #e5e5e5;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        input[type="text"], input[type="password"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #007BFF;
            outline: none;
            box-shadow: 0 0 4px rgba(0, 123, 255, 0.5);
        }

        input[type="button"] {
            background-color: #007BFF;
            color: #fff;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }

        input[type="button"]:hover {
            background-color: #0056b3;
        }

        .back-link {
            display: block;
            margin-bottom: 15px;
            text-align: left;
            color: #555;
            font-size: 14px;
        }

        .back-link:hover {
            color: #007BFF;
            text-decoration: underline;
        }

        label {
            display: block;
            text-align: left;
            margin-bottom: 5px;
            font-size: 14px;
            color: #555;
        }
    </style>
</head>
<body>

    <div class="form-container">
        <a href="PageLoginCliente.jsp" class="back-link">Voltar</a>
        <h2>Novo Cliente</h2>
        
        <label for="nome">Nome</label>
        <input type="text" id="nome" />
        
        <label for="email">E-mail</label>
        <input type="text" id="email" />
        
        <label for="senha">Senha</label>
        <input type="password" id="senha" />
        
        <label for="telefone">Telefone</label>
        <input type="text" id="telefone" />
        
        <input type="button" value="Concluir Cadastro" onclick="inserir()" />
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script type="text/javascript">
        function inserir(){
            var jsonEnvio = {};
            jsonEnvio.email = document.getElementById("email").value;
            jsonEnvio.nome = document.getElementById("nome").value;
            jsonEnvio.senha = document.getElementById("senha").value;
            jsonEnvio.telefone = document.getElementById("telefone").value;
            jsonEnvio.acao = "inserir";
            $.ajax({
                url: "ClienteServlet",
                data: jsonEnvio,
                type:"post",
                success: function (resp){
                    if (resp=="ok"){
                        alert("Cadastro com sucesso!");
                        document.location.href = "PageLoginCliente.jsp?email=" + jsonEnvio.email;
                    }else{
                        alert(resp)
                    }
                },
                error: function (){
                    alert("Ocorreu um erro ao cadastrar!!!");
                }
            });
        }
    </script>
    
</body>
</html>
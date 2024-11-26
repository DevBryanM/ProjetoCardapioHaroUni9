<%@ include file="ProtecaoFuncionario.jsp" %>

<%
	String nome = (String)session.getAttribute("nome_funcionario");
%>

<html>
<head>
	<meta charset="utf-8"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<title>Área Administrativa</title>
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

        .container {
            background-color: #e5e5e5;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        .welcome-message {
            font-size: 18px;
            color: #333;
            margin-bottom: 20px;
        }

        .button {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            font-size: 16px;
            font-weight: bold;
            color: #ffffff;
            background-color: #007BFF;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .button:hover {
            background-color: #0056b3;
        }

        .logout-button {
            background-color: #dc3545;
        }

        .logout-button:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="welcome-message">
            Seja bem-vindo, <b><%=nome%></b>!
        </div>
        
        <button class="button logout-button" onclick="fazer_logout()">Sair</button>

        <h2>Área Administrativa</h2>

        <a href="PageGerenciarFuncionario.jsp" class="button">Gerenciar Funcionários</a>
        <a href="PageGerenciarImoveis.jsp" class="button">Gerenciar Produtos</a>
        <a href="PageGerenciarCliente.jsp" class="button">Gerenciar Cliente</a>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        function fazer_logout() {
            var jsonEnvio = { acao: "logout" };
            $.ajax({
                url: "FuncionarioServlet",
                data: jsonEnvio,
                type: "post",
                success: function(resp) {
                    if (resp == "ok") {
                        document.location.href = "PageLogin.jsp";
                    } else {
                        alert("Ocorreu um erro ao realizar o logout!");
                    }
                }
            });
        }
    </script>
</body>
</html>
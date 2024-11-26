<%@ include file="ProtecaoFuncionario.jsp" %>

<html>
<head>
	<meta charset="utf-8"/>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.js" integrity="sha512-+k1pnlgt4F1H8L7t3z95o3/KO+o78INEcXTbnoJQ/F2VqDVhWoaiVml/OEHv9HsVgxUaVW+IbiZPUJQfF/YxZw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<title>Gerenciar Funcionário</title>
	<style>
        /* Centralização do conteúdo e estilos básicos */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f4f4f9;
        }

        .container {
            max-width: 800px;
            width: 100%;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            margin: 20px;
        }

        h2 {
            text-align: center;
            color: #333;
        }

        a {
            color: #007bff;
            text-decoration: none;
            margin-bottom: 10px;
            display: inline-block;
        }

        a:hover {
            text-decoration: underline;
        }

        form {
            margin-bottom: 20px;
        }

        form label {
            display: block;
            font-weight: bold;
            margin-top: 10px;
        }

        form input[type="text"],
        form input[type="password"] {
            width: calc(100% - 22px);
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        form input[type="button"],
        form input[type="reset"] {
            padding: 10px 15px;
            margin-top: 15px;
            margin-right: 5px;
            font-size: 16px;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        form input[type="button"] {
            background-color: #28a745;
        }

        form input[type="button"]:hover {
            background-color: #218838;
        }

        form input[type="reset"] {
            background-color: #dc3545;
        }

        form input[type="reset"]:hover {
            background-color: #c82333;
        }

        /* Estilos para a tabela */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #007bff;
            color: white;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #e9ecef;
        }

        .btn-edit, .btn-delete {
            cursor: pointer;
        }

        .btn-edit {
            color: #ffc107;
        }

        .btn-delete {
            color: #dc3545;
        }

    </style>
</head>
<body>
    <div class="container">
        <a href="PageAreaAdministrativa.jsp">Voltar</a>
        <h2>Gerenciar Funcionários</h2>

        <form>
            <label for="matricula">Matrícula</label>
            <input type="text" id="matricula" disabled />

            <label for="email">Email</label>
            <input type="text" id="email" />

            <label for="nome">Nome</label>
            <input type="text" id="nome" />

            <label for="senha">Senha</label>
            <input type="password" id="senha" />

            <input type="button" value="Buscar" onclick="consultar()" />
            <input type="button" value="Salvar" onclick="inserirOuAlterar()" />
            <input type="reset" value="Limpar" />
        </form>

        <table>
            <thead>
                <tr>
                    <th>Editar</th>
                    <th>Excluir</th>
                    <th>Matrícula</th>
                    <th>Email</th>
                    <th>Nome</th>
                </tr>
            </thead>
            <tbody id="corpo_da_tabela">
                <!-- As linhas da tabela serão inseridas dinamicamente aqui -->
            </tbody>
        </table>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function editar(matricula, email, nome) {
            document.getElementById("matricula").value = matricula;
            document.getElementById("email").value = email;
            document.getElementById("nome").value = nome;
        }

        function confirmarExcluir(matricula) {
            if (confirm("Deseja realmente excluir?")) {
                excluir(matricula);
            }
        }

        function inserirOuAlterar() {
            var jsonEnvio = {
                matricula: document.getElementById("matricula").value,
                email: document.getElementById("email").value,
                nome: document.getElementById("nome").value,
                senha: document.getElementById("senha").value,
                acao: document.getElementById("matricula").value ? "alterar" : "inserir"
            };

            $.ajax({
                url: "FuncionarioServlet",
                data: jsonEnvio,
                type: "post",
                success: function(resp) {
                    if (resp === "ok") {
                        alert("Funcionário cadastrado com sucesso!");
                        consultar();
                    } else {
                        alert(resp);
                    }
                },
                error: function() {
                    alert("Ocorreu um erro ao salvar!");
                }
            });
        }

        function consultar() {
            var jsonEnvio = { acao: "consultar" };

            $.ajax({
                url: "FuncionarioServlet",
                data: jsonEnvio,
                type: "post",
                success: function(resp) {
                    document.getElementById("corpo_da_tabela").innerHTML = resp;
                },
                error: function() {
                    alert("Ocorreu um erro ao consultar!");
                }
            });
        }

        function excluir(matricula) {
            var jsonEnvio = {
                acao: "excluir",
                matricula: matricula
            };

            $.ajax({
                url: "FuncionarioServlet",
                data: jsonEnvio,
                type: "post",
                success: function(resp) {
                    alert(resp);
                    consultar();
                },
                error: function() {
                    alert("Ocorreu um erro ao excluir!");
                }
            });
        }

        // Inicializar a tabela com os dados
        consultar();
    </script>
</body>
</html>
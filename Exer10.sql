use dbBANCO;

delete from tbTelefone_Cliente where CPF = 12345678911;

update tbConta set TipoConta = 2 where NumeroConta = 9879;


set sql_safe_updates = 0; -- Comando para desativar a trava de segurança contra o delete e o update

update tbCliente set Email = "Astro@Escola.com" where Nome = "Monica";

update tbConta set Saldo = Saldo * 1.1 where NumeroConta = 9876; -- Pode dar um aviso por talvez passar do limite decimal definido (7,2)

select Nome, Email, Endereco from tbCliente where Nome = "Monica";

update tbCliente set Nome = "Enildo Candido", Email = "enildo@escola.com" where Nome = "Enildo";

update tbConta set Saldo = Saldo - 30;

delete from tbHistorico where NumeroConta = 9878;
delete from tbConta where NumeroConta = 9878;
create database dbBANCO;
use dbBANCO;

create table tbCliente(
CPF bigint primary key,
Nome varchar(50) not null,
Sexo char(1) not null,
Endereco varchar(50) not null
);

create table tbBanco(
Codigo int primary key,
Nome varchar(50) not null
);

create table tbAgencia(
CodBanco int,
NumeroAgencia int primary key,
Endereco varchar(50) not null,
foreign key (CodBanco) references tbBanco(Codigo)
);

create table tbConta(
NumeroConta int primary key,
Saldo decimal(7,2),
TipoConta smallint,
NumAgencia int not null,
foreign key (NumAgencia) references tbAgencia(NumeroAgencia)
);

create table tbHistorico(
CPF bigint,
NumeroConta int,
DataInicio date,
foreign key (CPF) references tbCliente(CPF),
foreign key (NumeroConta) references tbConta(NumeroConta),
primary key(CPF, NumeroConta)
);

create table tbTelefone_Cliente(
CPF bigint,
Telefone int primary key, 
foreign key (CPF) references tbCliente(CPF)
);

insert into tbBanco (Codigo, Nome)
	values(1, "Banco do Brasil"),
		(104, "Caixa Economica Federal"),
		(801, "Banco Escola");

insert into tbAgencia (CodBanco, NumeroAgencia, Endereco)
	values (1, 123, "Av Paulista,78"),
		(104, 159, "Rua Liberdade,124"),
        (801, 401, "Rua vinte três,23"),
        (801, 485, "Av Marechal,68");
        
insert into tbCliente (CPF, Nome, Sexo, Endereco)
	values (12345678910, "Enildo", "M", "Rua Grande, 75"),
		(12345678911, "Astrogildo", "M", "Rua Pequena, 789"),
        (12345678912, "Monica", "F", "Av Larga, 148"),
        (12345678913, "Cascão", "M", "Av Principal, 369");
        
insert into tbConta (NumeroConta, Saldo, TipoConta, NumAgencia)
	values (9876, 456.05, 1, 123),
		(9877, 321, 1, 123),
        (9878, 100, 2, 485),
        (9879, 5589.48, 1, 401);
        
insert into tbHistorico (CPF, NumeroConta, DataInicio)
	values (12345678910, 9876, "2000-04-15"),
		(12345678911, 9877, "2011-03-10"),
        (12345678912, 9878, "2021-03-11"),
        (12345678913, 9879, "2000-07-05");
        
insert into tbTelefone_Cliente (CPF, Telefone)
	values (12345678910, 912345678),
		(12345678911, 912345679),
        (12345678912, 912345680),
        (12345678913, 912345681);
        
alter table tbCliente add Email varchar(50);

select CPF, Endereco from tbCliente where Nome = "Monica";

select NumeroAgencia, Endereco from tbAgencia where CodBanco = 801;

select * from tbCliente where Sexo = "M";


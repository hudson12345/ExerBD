create database dbDistribuidoraLTDA;
use dbDistribuidoraLTDA;


create table tbEstado(
UFId int auto_increment primary key,
UF char(2) not null
);

create table tbCidade(
CidadeId int auto_increment primary key,
Cidade varchar(200) not null
);

create table tbBairro(
BairroId int auto_increment primary key,
Bairro varchar(200) not null
);

create table tbEndereco(
Logradouro varchar(200) not null,
BairroId int not null, 
foreign key (BairroId) references tbBairro (BairroId),
CidadeId int not null, 
foreign key (CidadeId) references tbCidade (CidadeId),
UFId int not null, 
foreign key (UFId) references tbEstado (UFId),
id_Cep decimal(8,0) primary key
);

create table tbCliente(
id int auto_increment primary key,
NomeCli varchar(200) not null,
NumEnd decimal(6,0) not null,
CompEnd varchar(50), 
CepCli decimal(8,0), 
foreign key (CepCli) references tbEndereco (id_Cep)
);

create table tbClientePF(
id_CPF decimal(11,0) primary key,
RG decimal(9,0) not null,
RG_Dig char(1) not null,
Nasc date not null,
id int null, 
foreign key (id) references tbCliente (id)
);

create table tbClientePJ(
CNPJ decimal(14,0) primary key, 
IE decimal(11,0) unique,
id int null, 
foreign key (id) references tbCliente (id)
);

create table tbFornecedor(
Codigo int auto_increment primary key,
Nome varchar(200) not null,
CNPJ decimal(14,0) unique,
Telefone decimal(11,0)
);

create table tbCompra(
NotaFiscal int primary key,
DataCompra date not null,
ValorTotal decimal(8,2) not null,
QtdTotal int not null,
Codigo int,
foreign key (Codigo) references tbFornecedor (Codigo)
);

create table tbProduto(
CodigoBarras decimal(14,0) primary key,
Nome varchar(200) not null,
Valor decimal(8,2) not null,
Qtd int
);

create table tbNota_fiscal(
NF int primary key,
TotalNota decimal(8,2) not null,
DataEmissao date not null
);

create table tbItemCompra(
NotaFiscal int,
foreign key (NotaFiscal) references tbCompra (NotaFiscal),
CodigoBarras decimal(14,0),
foreign key (CodigoBarras) references tbProduto (CodigoBarras),
primary key (NotaFiscal, CodigoBarras),
ValorItem decimal(8,2) not null,
Qtd int not null
);

create table tbVenda(
NumeroVenda int primary key,
DataVenda date not null,
TotalVenda decimal(8,2) not null,
id_Cli int not null,
foreign key (id_Cli) references tbCliente (id),
NF int null, 
foreign key (NF) references tbNota_fiscal (NF)
);

create table tbItemVenda(
NumeroVenda int,
foreign key (NumeroVenda) references tbVenda (NumeroVenda),
CodigoBarras decimal(14,0),
foreign key (CodigoBarras) references tbProduto (CodigoBarras),
primary key (NumeroVenda, CodigoBarras),
ValorItem decimal(8,2) not null,
Qtd int not null
);

-- exer 1
insert into tbFornecedor
values
(1,'Revenda Chico Loco', 1245678937123, 11934567897),
(2,'José Faz Tudo S/A', 1346578937123,11934567898),
(3,'Vadalto Entregas', 1445678937123, 11934567899),
(4,'Astrogildo das Estrelas', 1545678937123, 11934567800),
(5,'Amoroso e Doce', 1645678937123, 11934567801),
(6,'Marcelo Dedal', 1745678937123, 11934567802),
(7,'ranciscano Cachaça', 1845678937123, 11934567803),
(8,'Joãozinho Chupeta', 1945678937123, 11934567804);


-- exer 2
delimiter $$

create procedure inserir_cidades(pCidade varchar(200))
begin
insert into tbCidade ( Cidade)
values ( pCidade);
end $$

delimiter ;

call inserir_cidades('Rio de Janeiro');
call inserir_cidades('São Carlos');
call inserir_cidades('Campinas');
call inserir_cidades('Franco da Rocha');
call inserir_cidades('Osasco');
call inserir_cidades('Pirituba');
call inserir_cidades('Lapa');
call inserir_cidades('Ponta Grossa');


-- exer 3
delimiter $$

create procedure inserir_estados( pUF char(2))
begin 
insert into tbEstado ( UF)
values ( pUF);
end $$

delimiter ;

call inserir_estados('SP');
call inserir_estados('RJ');
call inserir_estados('RS');


-- exer 4
delimiter $$

create procedure inserir_bairros( pBairro varchar(200))
begin
insert into tbBairro ( Bairro)
values ( pBairro);
end $$

delimiter ;

call inserir_bairros('Aclimação');
call inserir_bairros('Capão Redondo');
call inserir_bairros('Pirituba');
call inserir_bairros('Liberdade');


-- exer 5
delimiter $$

create procedure inserir_produto(
pCodigoBarras decimal(14,0),
pNome varchar(200),
pValor decimal(8,2),
pQtd int)
begin
insert into tbProduto (CodigoBarras, Nome, Valor, Qtd)
values (pCodigoBarras, pNome, pValor, pQtd);
end $$

delimiter ;

call inserir_produto(12345678910111, "Rei de Papel Mache", 54.61 ,120);
call inserir_produto(12345678910112, "Bolinha de Sabão", 100.45, 120);
call inserir_produto(12345678910113, "Carro Bate", 44.00, 120);
call inserir_produto(12345678910114, "Bola Furada", 10.00, 120);
call inserir_produto(12345678910115, "Maçã Laranja", 99.44, 120);
call inserir_produto(12345678910116, "Boneco do Hitler", 124.00, 200);
call inserir_produto(12345678910117, "Farinha de Suruí", 50.00, 200);
call inserir_produto(12345678910118, "Zelador de Cemitério", 24.50, 100);


-- exer 6
delimiter $$

create procedure inserir_endereco(
pLogradouro varchar(200),
pBairro varchar(200),
pCidade varchar(200),
pUF char(2),
pCep decimal(8,0))
begin   

-- comandos para caso algum registro esteja nulo
if (select BairroId from tbBairro where Bairro = pBairro) 
is null then call inserir_bairros(pBairro); 
end if;

if (select CidadeId from tbCidade where Cidade = pCidade)
is null then call inserir_cidades (pCidade);
end if;

if (select UFId from tbEstado where UF = pUF)
is null then call inserir_estados (pUF);
end if;

insert into tbEndereco (Logradouro, BairroId, CidadeId, UFId, id_Cep) 
values (pLogradouro,
(select BairroId from tbBairro where Bairro = pBairro),
(select CidadeId from tbCidade where Cidade = pCidade),
(select UFId from tbEstado where UF = pUF),
pCep);
end $$

delimiter ;


call inserir_endereco('Rua da Federal', 'Lapa', 'São Paulo', 'SP', 12345050);
call inserir_endereco('Av Brasil Lapa', 'Lapa', 'Campinas', 'SP', 12345051);
call inserir_endereco('Rua Liberdade', 'Consolação', 'São Paulo', 'SP', 12345052);
call inserir_endereco('Av Paulista', 'Penha', 'Rio De Janeiro', 'RJ', 12345053);
call inserir_endereco('Rua Ximbú', 'Penha', 'Rio De Janeiro', 'RJ', 12345054);
call inserir_endereco('Rua Piu XI', 'Penha', 'Campinas', 'SP', 12345055);
call inserir_endereco('Rua Chocolate', 'Aclimação', 'Barra Mansa', 'RJ', 12345056);
call inserir_endereco('Rua Pão na Chapa', 'Barra Funda' , 'Ponta Grossa', 'RS', 12345057);


-- exer 7
delimiter $$

create procedure inserir_clientespf(
pNomeCli varchar(200),
pNumEnd decimal(6,0),
pCompEnd varchar(50),
pLogradouro varchar(200),
pBairro varchar(200),
pCidade varchar(200),
pUF char(2),
pCep decimal(8,0),
pCPF decimal(11,0),
pRG decimal(9,0),
pRGDig char(1),
pNasc date)
begin

if not exists (select 1 from tbEndereco where id_Cep = pCep) then
call inserir_endereco(pLogradouro, pBairro, pCidade, pUF, pCep);
end if;

insert into tbCliente (NomeCli, NumEnd, CompEnd, CepCli)
values (pNomeCli, pNumEnd, pCompEnd, pCep);

-- Pega o ID do último cliente cadastrado para vincular com os dados da pessoa
insert into tbClientePF (id, id_CPF, RG, RG_Dig, Nasc)
values ((select max(id) from tbCliente), pCPF, pRG, pRGDig, pNasc);
end $$

delimiter ;

call inserir_clientespf(
'Pimpão', 325, null,
'Av Brasil', 'Lapa', 'Campinas', 'SP', 12345051,
12345678911, 12345678, '0', '2000-10-12'
);

call inserir_clientespf(
'Disney Chaplin', 89, 'Ap. 12',
'Av Paulista', 'Penha', 'Rio de Janeiro', 'RJ', 12345053,
12345678912, 12345679, '0', '2001-11-21'
);

call inserir_clientespf(
'Marciano', 744, null,
'Rua Ximbú', 'Penha', 'Rio de Janeiro', 'RJ', 12345054,
12345678913, 12345680, '0', '2001-06-01'
);

call inserir_clientespf(
'Lança Perfume', 128, null,
'Rua Veia', 'Jardim Santa Isabel', 'Cuiabá', 'MT', 12345059,
12345678914, 12345681, 'X', '2004-04-05'
);

call inserir_clientespf(
'Remédio Amargo', 2585, null,
'Av Nova', 'Jardim Santa Isabel', 'Cuiabá', 'MT', 12345058,
12345678915, 12345682, '0', '2002-07-15'
);


-- exer 8
delimiter $$

create procedure inserir_clientespj(
pNomeCli varchar(200),
pCNPJ decimal (14,0),
pIE decimal (11,0),
pCep decimal(8,0),
pLogradouro varchar(200),
pNumEnd decimal(6,0),
pCompEnd varchar(50),
pBairro varchar(200),
pCidade varchar(200),
pUF char(2))
begin

if not exists (select 1 from tbEndereco where id_Cep = pCep) then
call inserir_endereco(pLogradouro, pBairro, pCidade, pUF, pCep);
end if;

insert into tbCliente (NomeCli, NumEnd, CompEnd, CepCli)
values (pNomeCli, pNumEnd, pCompEnd, pCep);

insert into tbClientePJ (id, CNPJ, IE)
values ((select max(id) from tbCliente), pCNPJ, pIE);
    
end $$

delimiter ;

call inserir_clientespj(
'Paganada', 12345678912345, 98765432198,
12345051, 'Av Brasil', 159, null, 'Lapa',
'Campinas', 'SP'
);

call inserir_clientespj(
'Caloteando', 12345678912346, 98765432199,
12345053, 'Av Paulista', 69, null, 'Penha',
'Rio de Janeiro', 'RJ'
);

call inserir_clientespj(
'Semgrana', 12345678912347, 98765432100,
12345060, 'Rua dos Amores', 189, null,
'Sei Lá', 'Recife', 'PE'
);

call inserir_clientespj(
'Cemreais', 12345678912348, 98765432101,
12345060, 'Rua dos Amores', 5024, 'Sala 23', 
'Sei Lá', 'Recife', 'PE'
);

call inserir_clientespj(
'Durango', 12345678912349, 98765432102,
12345060, 'Rua dos Amores', 1254, null,
'Sei Lá', 'Recife', 'PE'
);


-- exer 9
delimiter $$

create procedure inserir_compra(
pNotaFiscal int,
pFornecedor varchar(200),
pDataCompra varchar(10),
pCodigoBarras decimal(14,0),
pValorItem decimal(8,2),
pQtd int,
pQtdTotal int,
pValorTotal decimal(8,2)
)
begin 
declare FornecedorId int;
declare ExisteNotaId int;

select Codigo into FornecedorId from tbFornecedor where Nome = pFornecedor;

if FornecedorId is not null then 
-- Verifica se existe um produto cadastrado com o código de barras informado
if exists (select 1 from tbProduto where CodigoBarras = pCodigoBarras) then

select count(*) into ExisteNotaId from tbCompra where NotaFiscal = pNotaFiscal;

-- Se a nota fiscal não existe, então cria uma nova compra
if ExisteNotaId = 0 then
insert into tbCompra (NotaFiscal, DataCompra, ValorTotal, QtdTotal, Codigo)
-- Utiliza a função para transformar os dados inseridos em formato de data
values (pNotaFiscal, str_to_date(pDataCompra, '%d/%m/%Y'), pValorTotal, pQtdTotal, FornecedorId);
end if;

insert into tbItemCompra (NotaFiscal, CodigoBarras, ValorItem, Qtd)
values(pNotaFiscal, pCodigoBarras, pValorItem, pQtd);

end if; 
end if;
    
end $$

delimiter ;

call inserir_compra(
8459, 'Amoroso e Doce', '01/05/2018',
12345678910111, 22.22, 200, 700, 21944.00
);

call inserir_compra(
2482, 'Revenda Chico Loco', '22/04/2020',
12345678910112, 40.50, 180, 180, 7290.00
);

call inserir_compra(
21563, 'Marcelo Dedal', '12/07/2020',
12345678910113, 3.00, 300, 300, 900.00
);

call inserir_compra(
8459, 'Amoroso e Doce', '01/05/2018',
12345678910114, 35.00, 500, 700, 21944.00
);

call inserir_compra(
156354, 'Revenda Chico Loco', '23/11/2021',
12345678910115, 54.00, 350, 350, 18900.00
);


-- exer 10 
delimiter $$

create procedure inserir_vendas (
pNumeroVenda int,
pCliente varchar(200),  
pCodigoBarras decimal(14,0),
pQtd int
)

begin 
declare ValorProduto decimal (8,2);
declare IdCliente int;

if exists(select 1 from tbCliente where NomeCli = pCliente)
and exists(select 1 from tbProduto where CodigoBarras = pCodigoBarras)
then

set IdCliente = (select Id from tbCliente where NomeCli = pCliente);
set ValorProduto = (select Valor from tbProduto where CodigoBarras = pCodigoBarras);

insert into tbVenda(Id_Cli, NumeroVenda, DataVenda, TotalVenda) 
-- Utiliza uma função para pegar a data atual do sistema
values(IdCliente, pNumeroVenda, curdate(), (ValorProduto * pQtd));

insert into tbItemVenda(NumeroVenda, CodigoBarras, ValorItem, Qtd) 
values(pNumeroVenda, pCodigoBarras, ValorProduto, pQtd);

end if ;

end $$

delimiter ;

call inserir_vendas(1, "Pimpão", 12345678910111, 1);
call inserir_vendas(2, "Lança Perfume", 12345678910112, 2);
call inserir_vendas(3, "Pimpão", 12345678910113, 1);


-- exer 11 
delimiter $$

create procedure inserir_notafiscal(pNF int, pClienteNota varchar(200))
begin
    declare IdCliente int;
    declare TotalNota decimal (8,2);

-- Descobre o ID do Cliente pelo nome
select Id into IdCliente from tbCliente where NomeCli = pClienteNota;
    
if IdCliente is not null then 

-- Verifica se existem vendas desse cliente que ainda não têm Nota Fiscal
if exists (select 1 from tbVenda where Id_Cli = IdCliente AND NF IS NULL) then 
            
-- Calcula o total somando apenas as vendas que ainda não têm nota
select sum(TotalVenda) into TotalNota from tbVenda where Id_Cli = IdCliente AND NF IS NULL;

-- Insere a Nota Fiscal (SEM o ID do Cliente)
insert into tbNota_fiscal(NF, DataEmissao, TotalNota)
values(pNF, curdate(), TotalNota);

-- Atualiza as vendas desse cliente para vincular a essa nota
update tbVenda 
set NF = pNF 
where Id_Cli = IdCliente AND NF IS NULL;

end if; 
end if;

end $$

delimiter ;


call inserir_notafiscal(359, 'Pimpão');
call inserir_notafiscal(360, 'Lança Perfume');


-- exer 12
delimiter $$

drop procedure if exists inserir_produto $$ -- para evitar duplicidade de procedure (ou eu poderia só trocar o nome de uma)

create procedure inserir_produto(
pCodigoBarras decimal(14,0),
pNome varchar(200),
pValorUnit decimal(8,2),
pQtd int
)

begin

if not exists(select 1 from tbProduto where CodigoBarras = pCodigoBarras) then
insert into tbProduto(CodigoBarras, Nome, Valor, Qtd)
values(pCodigoBarras, pNome, pValorUnit, pQtd);

end if;

end $$


delimiter ;

call inserir_produto(12345678910130, 'Camiseta de Poliéster', 35.61, 100);
call inserir_produto(12345678910131, 'Blusa Frio Moletom', 200.00, 100);
call inserir_produto(12345678910132, 'Vestido Decote Redondo', 144.00, 50);


-- exer 13
delimiter $$ 

create procedure deletar_produto(pCodigoBarras decimal(14,0))
begin

if exists (select 1 from tbProduto where CodigoBarras = pCodigoBarras) then

delete from tbProduto
where CodigoBarras = pCodigoBarras;
end if;

end $$

delimiter ;

call deletar_produto(12345678910116);
call deletar_produto(12345678910117);


-- exer 14
delimiter $$

create procedure atualizar_produto(
pCodigoBarras decimal(14,0),
pNome varchar(200),
pValorUnitario decimal(8,2)
)
begin

if exists (select 1 from tbProduto where CodigoBarras = pCodigoBarras) then

update tbProduto
set Nome = pNome, Valor = pValorUnitario
where CodigoBarras = pCodigoBarras;
end if;

end $$

delimiter ;

call atualizar_produto(12345678910113, 'Rei de Papel Mache', 64.50);
call atualizar_produto(12345678910112, 'Bolinha de Sabão', 120.00);
call atualizar_produto(12345678910113, 'Carro Bate Bate', 64.00 );


-- exer 15
delimiter $$

create procedure mostrar_produtos()
begin
    select * from tbProduto;
end $$

delimiter ;

call mostrar_produtos;

show tables;
select * from tbEndereco;
select * from tbProduto;
select * from tbCliente;
select * from tbClientePF;
select * from tbClientePJ;
select * from tbCompra;
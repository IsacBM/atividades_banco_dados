create table exame(
  cod_exame serial primary key,
  nome varchar(30) not null
);

create table cid(
  cod_cid int primary key,
  nome varchar(60) not null unique
);

create table paciente(
  cpf numeric(11,0) primary key,
  nome varchar(40) not null,
  sexo char(1) not null,
  cor varchar(20) not null,
  data_nascimento date not null
);

create table tipo_medico(
  cod_tipo serial primary key,
  nome varchar(30) not null unique
);

CREATE TABLE titulacao(
	cod_titulacao int PRIMARY KEY,
	nome varchar NOT null
);



create table medico(
  crm numeric(15,0) primary key,
  nome varchar(40) not null,
  cod_tipo int not NULL,
  cod_titulacao int REFERENCES titulacao(cod_titulacao)
);

alter table medico
add constraint tipo_medico_fk foreign key(cod_tipo) references tipo_medico(cod_tipo) 

create table pedido_exame(
  cod_pedido serial primary key,
  data_emissao date not null,
  hora_emissao time not null,
  data_prevista_realizacao date not null,
  data_realizacao date not null,
  cpf numeric(11,0) not null,
  cod_cid int not null,
  cod_exame int not null,
  crm numeric(15,0) not null  
);

alter table pedido_exame
add constraint paciente_fk foreign key(cpf) references paciente(cpf);

alter table pedido_exame
add constraint cid_fk foreign key(cod_cid) references cid(cod_cid);

alter table pedido_exame
add constraint exame_fk foreign key(cod_exame) references exame(cod_exame);

alter table pedido_exame
add constraint medico_fk foreign key(crm) references medico(crm);

alter table pedido_exame
add constraint checa_datas check(data_prevista_realizacao <= data_realizacao);

create table realizacao_exame(
  cod_pedido int,
  data_realizacao date,
  hora_realizacao time
);

alter table realizacao_exame
add constraint pedido_exame_fk foreign key(cod_pedido) references pedido_exame(cod_pedido);

alter table realizacao_exame
add constraint realizacao_exame_pk primary key(cod_pedido);


create table laudo(
  cod_laudo serial primary key,
  conclusao text not null,
  data_emissao date not null,
  data_revisao date,
  status char(1), 
  cod_pedido int not null,
  cod_cid int not null,
  crm_emite numeric(15,0) not null,
  crm_valida numeric(15,0) not null
);

alter table laudo
add constraint pedido_fk foreign key(cod_pedido) references pedido_exame(cod_pedido);

alter table laudo
add constraint cid_fk foreign key(cod_cid) references cid(cod_cid);

alter table laudo
add constraint medico_emissor_fk foreign key(crm_emite) references medico(crm);

alter table laudo
add constraint medico_revisor_fk foreign key(crm_valida) references medico(crm);

-- Povoamento:


-- Populando a tabela exame
INSERT INTO exame (nome) VALUES
('Hemograma'),
('Raio-X'),
('Ultrassonografia'),
('Tomografia'),
('Eletrocardiograma');

-- Populando a tabela cid
INSERT INTO cid (cod_cid, nome) VALUES
(1, 'Gripe'),
(2, 'Fratura no braço'),
(3, 'Diabetes Tipo 2'),
(4, 'Hipertensão'),
(5, 'Covid-19');

-- Populando a tabela paciente
INSERT INTO paciente (cpf, nome, sexo, cor, data_nascimento) VALUES
(12345678901, 'Ana Souza', 'F', 'Parda', '1985-03-22'),
(23456789012, 'Carlos Silva', 'M', 'Branca', '1990-07-15'),
(34567890123, 'Maria Oliveira', 'F', 'Preta', '1978-11-30'),
(45678901234, 'João Mendes', 'M', 'Amarela', '2000-01-10'),
(56789012345, 'Juliana Rocha', 'F', 'Branca', '1995-06-08');

-- Populando a tabela tipo_medico
INSERT INTO tipo_medico (nome) VALUES
('Clínico Geral'),
('Ortopedista'),
('Cardiologista'),
('Endocrinologista'),
('Pediatra');

-- Populando a tabela titulacao
INSERT INTO titulacao (cod_titulacao, nome) VALUES
(1, 'Especialista'),
(2, 'Mestre'),
(3, 'Doutor');

-- Populando a tabela medico
INSERT INTO medico (crm, nome, cod_tipo, cod_titulacao) VALUES
(111111, 'Dr. Paulo Lima', 1, 2),
(222222, 'Dra. Renata Reis', 2, 1),
(333333, 'Dr. Tiago Rocha', 3, 3),
(444444, 'Dra. Camila Nunes', 4, 2),
(555555, 'Dr. Henrique Borges', 5, 1);

INSERT INTO medico (crm, nome, cod_tipo, cod_titulacao) VALUES
(666666, 'Raimundo Santos', 2, 2);

-- Populando a tabela pedido_exame
INSERT INTO pedido_exame (
  data_emissao, hora_emissao, data_prevista_realizacao, data_realizacao,
  cpf, cod_cid, cod_exame, crm
) VALUES
('2025-05-01', '08:00', '2025-05-02', '2025-05-02', 12345678901, 1, 1, 111111),
('2025-05-03', '09:30', '2025-05-04', '2025-05-04', 23456789012, 2, 2, 222222),
('2025-05-05', '14:00', '2025-05-06', '2025-05-06', 34567890123, 3, 3, 333333),
('2025-05-07', '10:45', '2025-05-08', '2025-05-08', 45678901234, 4, 4, 444444),
('2025-05-09', '11:15', '2025-05-10', '2025-05-10', 56789012345, 5, 5, 555555);

-- Populando a tabela realizacao_exame
INSERT INTO realizacao_exame (cod_pedido, data_realizacao, hora_realizacao) VALUES
(1, '2025-05-02', '08:30'),
(2, '2025-05-04', '10:00'),
(3, '2025-05-06', '14:15'),
(4, '2025-05-08', '11:00'),
(5, '2025-05-10', '11:45');

-- Populando a tabela laudo
INSERT INTO laudo (
  conclusao, data_emissao, data_revisao, status,
  cod_pedido, cod_cid, crm_emite, crm_valida
) VALUES
('Paciente com sintomas leves de gripe.', '2025-05-02', '2025-05-03', 'A', 1, 1, 111111, 555555),
('Fratura confirmada no antebraço esquerdo.', '2025-05-04', '2025-05-05', 'A', 2, 2, 222222, 111111),
('Níveis elevados de glicose no sangue.', '2025-05-06', null, 'P', 3, 3, 333333, 444444),
('Pressão arterial acima do normal.', '2025-05-08', '2025-05-09', 'A', 4, 4, 444444, 222222),
('Resultado positivo para Covid-19.', '2025-05-10', null, 'P', 5, 5, 555555, 333333);


-- Populando a tabela exame
INSERT INTO exame (nome) VALUES
('Hemograma'),
('Raio-X'),
('Ultrassonografia'),
('Tomografia'),
('Eletrocardiograma'),
('Exame de Sangue');

-- Populando a tabela paciente
INSERT INTO paciente (cpf, nome, sexo, cor, data_nascimento) VALUES
(11111111111, 'Manoel Sousa', 'M', 'Parda', '1980-01-15'),
(22222222222, 'Maria Silva', 'F', 'Branca', '1992-02-20'),
(33333333333, 'Carlos Souza', 'M', 'Preta', '1987-03-05'),
(44444444444, 'Ana Souza', 'F', 'Parda', '1985-03-22');

-- Populando a tabela tipo_medico
INSERT INTO tipo_medico (nome) VALUES
('Clínico Geral'),
('Ortopedista'),
('Cardiologista');

-- Populando a tabela titulacao
INSERT INTO titulacao (cod_titulacao, nome) VALUES
(1, 'Especialista'),
(2, 'Mestre'),
(3, 'Doutor');

-- Populando a tabela medico
INSERT INTO medico (crm, nome, cod_tipo, cod_titulacao) VALUES
(101010, 'Raimundo Santos', 1, 1),
(202020, 'Ana Oliveira', 2, 2),
(303030, 'João Cardoso', 3, 3);

-- Populando a tabela pedido_exame
INSERT INTO pedido_exame (
  data_emissao, hora_emissao, data_prevista_realizacao, data_realizacao,
  cpf, cod_cid, cod_exame, crm
) VALUES
('2021-05-10', '09:00', '2021-05-12', '2021-05-12', 33333333333, 1, 2, 101010), -- Para query b
('2022-01-15', '10:00', '2022-01-16', '2022-01-16', 11111111111, 2, 1, 101010), -- Para query d
('2022-03-10', '11:00', '2022-03-11', '2022-03-11', 22222222222, 1, 1, 202020), -- Para query e
('2022-03-10', '12:00', '2022-03-12', '2022-03-12', 22222222222, 1, 1, 202020), -- Exame de sangue para query c
('2021-05-20', '08:00', '2021-05-21', '2021-05-21', 44444444444, 2, 3, 101010); -- Para query a

-- Populando a tabela realizacao_exame
INSERT INTO realizacao_exame (cod_pedido, data_realizacao, hora_realizacao) VALUES
(6, '2021-05-12', '09:15'),
(7, '2022-01-16', '10:30'),
(8, '2022-03-11', '11:30'),
(9, '2022-03-12', '12:15'),
(10, '2021-05-21', '08:30');

-- Populando a tabela laudo
INSERT INTO laudo (
  conclusao, data_emissao, data_revisao, status,
  cod_pedido, cod_cid, crm_emite, crm_valida
) VALUES
('Anemia detectada, recomendada suplementação de ferro.', '2022-01-16', null, 'A', 2, 2, 101010, 303030),
('Exame normal.', '2022-03-11', null, 'A', 3, 1, 202020, 303030);


-- Fim povoamento <----

-- Inicio das questões:

-- a)
create or replace view pacientes_raimundo_santos as
select paciente.nome, sexo from paciente
inner join pedido_exame using(cpf)
inner join medico using(crm)
where medico.nome = 'Raimundo Santos'

select * from pacientes_raimundo_santos;

-- b)
create or replace view pacientes_2021 as
select * from cid
inner join pedido_exame using(cod_cid)
where data_emissao > '2021-05-01' and data_emissao < '2021-05-31';

select * from pacientes_2021;

-- c)
create or replace view titulacoes as
select titulacao.nome from medico
inner join titulacao using(cod_titulacao)
inner join pedido_exame using(crm)
inner join exame using(cod_exame)
where exame.nome = 'Hemograma'

select * from titulacoes;

-- d)
create or replace view laudo_manuel as
select cod_laudo, conclusao from laudo
inner join pedido_exame using(cod_pedido)
right join paciente using(cpf)
where paciente.nome = 'Carlos Silva' and laudo.data_emissao > '2025-01-01'

select * from laudo_manuel;

-- e)
create or replace view exames_maria as
select data_prevista_realizacao from pedido_exame
inner join medico using(crm)
inner join paciente using(cpf)
where paciente.nome = 'Maria Silva' and medico.nome = 'Ana Oliveira'

select * from exames_maria
create table departamento(
	id_departamento int primary key,
	nome_departamento varchar(40) not null
);

create table funcionario(
	matricula_funcionario int primary key,
	nome varchar(30) not null,
	data_nascimento date not null,
	salario numeric(7,2) not null,
	id_departamento int,
	constraint id_departamento_fk foreign key(id_departamento) references departamento(id_departamento)
);

create table projeto(
	id_projeto int primary key,
	nome varchar(50) not null,
	duracao int not null
);

create table participa(
	matricula_funcionario int,
	id_projeto int,
	horas_trabalhadas int not null,
	constraint matricula_id_pk primary key(matricula_funcionario, id_projeto)
);

insert into projeto values(1, 'Projeto X', 0);
insert into projeto values(2, 'Projeto Y', 0);
insert into projeto values(3, 'Projeto Z', 0);

insert into departamento values(1, 'TI');
insert into departamento values(2, 'Marketing');
insert into departamento values(3, 'Comercial');

insert into funcionario values(1, 'Maria', '30/06/2000', 5000, 1);
insert into funcionario values(2, 'Joao', '13/05/2001', 6000, 2);
insert into funcionario values(3, 'Amanda', '12/08/2001', 7000, 3);
insert into funcionario values(4, 'Francisco', '02/06/1990', 5000, 1);
insert into funcionario values(5, 'Enzo', '25/07/1999', 4000, 2);
insert into funcionario values(6, 'Mychelle', '02/02/1988', 6000, 3);

select * from projeto;

drop function cadastrar;

create or replace function cadastrar(matricula int, proj int, horas int) returns int
as
$$
begin
	perform * from funcionario where matricula_funcionario = matricula;
	if not found then
		raise notice 'Funcionario de matricula % não existe!', matricula;
		return -1;
	else
		perform * from projeto where id_projeto = proj;
		if not found then
			raise notice 'O projeto % não está cadastrado!', proj;
			return -1;
		else
			if horas <= 0 then
				raise notice 'Quantidade de horas inválidas!';
				return -1;
			else
				insert into participa values(matricula, proj, horas);
				raise notice 'Participação cadastrada com sucesso!';
				return 1;
			end if;
		end if;
	end if;

exception 
	when unique_violation then
		raise notice 'Este funcionario já está neste projeto!';
		return -1;
end;
$$
language plpgsql;

select * from funcionario;


-- Testando a função:
select * from cadastrar(1,1,10);

-- Testando o resultado:
select * from participa;
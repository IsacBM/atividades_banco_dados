create table alunos(
	id_aluno int primary key,
	nome varchar(60) not null
);

insert into alunos values(1, 'Isac Brito Matos');
insert into alunos values(2, 'Cleriton Savio');

select * from alunos

--  Usar o replace
drop function get_nome_aluno(int) -- mexer nos parametros
create or replace function get_nome_aluno(id int) returns varchar
as
$$
declare
	registro record;
begin
	select * into registro from alunos where id_aluno = id;
	return registro.nome;
end; -- Ponto e virgula aqui é obrigatorio!

$$
language plpgsql;

select get_nome_aluno(1); -- Forma de Chamar a função...

-- Part 2

drop function get_alunos(int) -- mexer nos parametros
create or replace function get_alunos(id int) returns varchar
as
$$
declare
	registro alunos%rowtype;
begin
	perfrom * into registro from alunos where id_aluno = id;
	if found then
		return 'Existe!';
	else
		return 'Rum!';
	end if;

end; -- Ponto e virgula aqui é obrigatorio!

$$
language plpgsql;

select get_alunos(2); -- Forma de Chamar a função...

-- Estudos:
-- create or replace function pegar_nome (id int) returns varchar as
-- $$
-- begin
-- 	return 'Olá Mundo';
-- end;
-- $$
-- language plpgsql;


-- select pegar_nome(2)

create or replace function add_aluno(novo_id int, novo_aluno varchar) returns int
as
$$
begin
	insert into alunos values(novo_id, novo_aluno);
	if found then
		raise notice 'Aluno cadastrado com sucesso!';
		return 1;
	end if;

exception 
	when unique_violation then
	raise notice 'Erro ao cadastrar o aluno!';
	return -1;
end;
$$
language plpgsql;

select add_aluno(3, 'Rangel');

select * from alunos;
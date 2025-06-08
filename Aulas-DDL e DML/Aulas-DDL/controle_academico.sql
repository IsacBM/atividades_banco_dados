create table aluno(
	codigo_aluno int primary key,
	nome varchar(40) not null
);

create table instituicao(
	codigo_instituicao int primary key,
	nome_instituicao varchar(40) not null,
	sigla varchar(10) not null
);

create table campus(
	codigo_campus int primary key,
	nome_campus varchar(40) not null,
	codigo_instituicao int not null,
	logradouro varchar(50) not null,
	bairro varchar(30) not null,
	cidade varchar(30) not null,
	estado varchar(2) not null,
	constraint fk_cod_instituicao foreign key(codigo_instituicao) references instituicao(codigo_instituicao)
);

create table curso(
	codigo_curso int primary key,
	nome_curso varchar(40) not null,
	codigo_campus int not null,
	constraint fk_cod_campus foreign key(codigo_campus) references campus(codigo_campus)
);

create table professor(
	codigo_professor int primary key,
	nome_professor varchar(40) not null,
	codigo_campus int not null,
	constraint fk_cod_campus foreign key(codigo_campus) references campus(codigo_campus)
);

create table projeto(
	codigo_projeto int primary key,
	nome_projeto varchar(40) not null,
	CH int not null check (CH >= 12 and CH <= 40),
	codigo_professor int not null,
	constraint fk_cod_professor foreign key(codigo_professor) references professor(codigo_professor)
);

create table disciplina(
	codigo_disciplina int primary key,
	nome_disciplina varchar(40) not null,
	codigo_curso int not null,
	constraint fk_cod_curso foreign key(codigo_curso) references curso(codigo_curso)
);

create table oferta_disciplina(
	oferta_disciplina int primary key,
	codigo_professor int not null,
	codigo_disciplina int not null,
	constraint fk_cod_professor foreign key(codigo_professor) references professor(codigo_professor),
	constraint fk_cod_disciplina foreign key(codigo_disciplina) references disciplina(codigo_disciplina)
);

create table matricula(
	numero_matricula numeric(6) primary key,
	codigo_aluno int not null,
	codigo_curso int not null,
	constraint fk_cod_aluno foreign key(codigo_aluno) references aluno(codigo_aluno),
	constraint fk_cod_curso foreign key(codigo_curso) references curso(codigo_curso)
);

create table matricula_disciplina(
	codigo_matricula_disciplina int primary key,
	nota numeric(3,2) not null,
	situacao varchar(30) not null,
	numero_matricula numeric(6) not null,
	oferta_disciplina int not null,
	constraint fk_num_matricula foreign key(numero_matricula) references matricula(numero_matricula),
	constraint fk_oferta_disciplina foreign key(oferta_disciplina) references oferta_disciplina(oferta_disciplina)
);

create table ausencias(
	cod_ausencia int primary key,
	data_falta date not null,
	codigo_matricula_disciplina int not null,
	qtd_faltas int not null,
	constraint fk_cod_matricula_disciplina foreign key(codigo_matricula_disciplina) references matricula_disciplina(codigo_matricula_disciplina)
);

create table inscricao_projeto(
	codigo_projeto int not null,
	numero_matricula numeric(6) not null,
	constraint fk_codigo_projeto foreign key(codigo_projeto) references projeto(codigo_projeto),
	constraint fk_numero_matricula foreign key(numero_matricula) references matricula(numero_matricula),
	constraint inscricao_projeto_pk primary key(codigo_projeto, numero_matricula)
);

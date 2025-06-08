create or replace view programacao as
select nome, titulo from palestra
inner join palestra_palestrante using(id_palestrante)
inner join palestrante using(id_palestra);
-- Essa guardo apenas o select(O código da chamada, ou seja, dá tipo um apelido com as alterações)

create materialized view programacao as
select nome, titulo from palestra
inner join palestra_palestrante using(id_palestrante)
inner join palestrante using(id_palestra);
-- Essa salva os dados em uma view unindo as tabelas

refresh materialized view programacao -- Atualiza os dados que foram inseridos depois da criação da view.
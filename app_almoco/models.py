from django.db import models


class Pessoa(models.Model):
	id_pessoa = models.AutoField(primary_key=True, db_column='id_pessoa')
	nome_completo = models.CharField(max_length=45, db_column='nome_completo')
	telefone = models.CharField(max_length=45, db_column='telefone')

	class Meta:
		db_table = 'pessoa'
		managed = True
		ordering = ['nome_completo']

	def __str__(self) -> str:
		return f"{self.nome_completo}"


class DiaAlmoco(models.Model):
	id_dia_almoco = models.AutoField(primary_key=True, db_column='id_dia_almoco')
	dia = models.DateField(db_column='dia')
	pessoa = models.ForeignKey(Pessoa, db_column='pessoa_id_pessoa', on_delete=models.CASCADE)

	class Meta:
		db_table = 'dia_almoco'
		managed = True

	def __str__(self) -> str:
		return f"{self.dia} -> {self.pessoa}"


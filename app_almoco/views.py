from django.shortcuts import render, redirect
from django.http import JsonResponse, HttpResponseBadRequest, HttpResponseForbidden
from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_exempt
from .models import Pessoa, DiaAlmoco
import datetime
import calendar
import json


def index(request):
	# require login via session
	pessoa_id = request.session.get('pessoa_id')
	if not pessoa_id:
		return redirect('app_almoco:login')

	pessoa_name = request.session.get('pessoa_name')
	today = datetime.date.today()
	year = int(request.GET.get('year', today.year))
	month = int(request.GET.get('month', today.month))

	# month names in Portuguese
	months_pt = [
		'janeiro','fevereiro','março','abril','maio','junho',
		'julho','agosto','setembro','outubro','novembro','dezembro'
	]
	month_name = months_pt[month-1].capitalize()
	_, days_in_month = calendar.monthrange(year, month)

	# gather reservations for this month
	start = datetime.date(year, month, 1)
	end = datetime.date(year, month, days_in_month)
	reservations_qs = DiaAlmoco.objects.filter(dia__range=(start, end)).select_related('pessoa')
	current_pessoa_id = request.session.get('pessoa_id')
	reservations = {
		r.dia.isoformat(): {
			'nome': r.pessoa.nome_completo,
			'telefone': r.pessoa.telefone,
			'owned': (r.pessoa_id == current_pessoa_id)
		}
		for r in reservations_qs
	}

	context = {
		'year': year,
		'month': month,
		'month_name': month_name,
		'days_in_month': days_in_month,
		'first_weekday': calendar.monthrange(year, month)[0],
		'reservations_json': json.dumps(reservations),
		'pessoa_name': pessoa_name,
	}
	return render(request, 'app_almoco/index.html', context)


@require_POST
def save_reservation(request):
	try:
		data = json.loads(request.body.decode('utf-8'))
		dia = data.get('dia')  # expected YYYY-MM-DD
		if not dia:
			return HttpResponseBadRequest('Missing dia')

		dia_date = datetime.date.fromisoformat(dia)

		# if user is logged in, use that Pessoa
		pessoa = None
		pessoa_id = request.session.get('pessoa_id')
		if pessoa_id:
			try:
				pessoa = Pessoa.objects.get(pk=pessoa_id)
			except Pessoa.DoesNotExist:
				pessoa = None

		if not pessoa:
			nome = data.get('nome')
			telefone = data.get('telefone')
			if not (nome and telefone):
				return HttpResponseBadRequest('Missing fields')
			pessoa, _ = Pessoa.objects.get_or_create(nome_completo=nome, telefone=telefone)

		# If there's already a reservation for the day, do not overwrite another user's reservation
		existing = DiaAlmoco.objects.filter(dia=dia_date).select_related('pessoa').first()
		if existing:
			# if same pessoa, return existing info
			if pessoa and existing.pessoa_id == pessoa.pk:
				return JsonResponse({'dia': dia, 'nome': pessoa.nome_completo, 'telefone': pessoa.telefone})
			# otherwise, reject the attempt to reserve an already booked day
			return HttpResponseBadRequest('Dia já reservado por outra pessoa')

		# create new reservation for the day
		obj = DiaAlmoco.objects.create(dia=dia_date, pessoa=pessoa)
		return JsonResponse({'dia': dia, 'nome': pessoa.nome_completo, 'telefone': pessoa.telefone, 'owned': True})
	except Exception as e:
		return HttpResponseBadRequest(str(e))


@require_POST
def delete_reservation(request):
	try:
		data = json.loads(request.body.decode('utf-8'))
		dia = data.get('dia')
		if not dia:
			return HttpResponseBadRequest('Missing dia')
		dia_date = datetime.date.fromisoformat(dia)
		# only the user who created the reservation can delete it
		pessoa_id = request.session.get('pessoa_id')
		if not pessoa_id:
			return HttpResponseForbidden('Usuário não autenticado')
		existing = DiaAlmoco.objects.filter(dia=dia_date).first()
		if not existing:
			return HttpResponseBadRequest('Reserva não encontrada')
		if existing.pessoa_id != pessoa_id:
			return HttpResponseForbidden('Você não tem permissão para desmarcar esta reserva')
		existing.delete()
		return JsonResponse({'dia': dia})
	except Exception as e:
		return HttpResponseBadRequest(str(e))


def get_reservations(request):
	try:
		today = datetime.date.today()
		year = int(request.GET.get('year', today.year))
		month = int(request.GET.get('month', today.month))

		_, days_in_month = calendar.monthrange(year, month)
		start = datetime.date(year, month, 1)
		end = datetime.date(year, month, days_in_month)
		reservations_qs = DiaAlmoco.objects.filter(dia__range=(start, end)).select_related('pessoa')
		current_pessoa_id = request.session.get('pessoa_id')
		reservations = {
			r.dia.isoformat(): {
				'nome': r.pessoa.nome_completo,
				'telefone': r.pessoa.telefone,
				'owned': (r.pessoa_id == current_pessoa_id)
			}
			for r in reservations_qs
		}
		return JsonResponse(reservations)
	except Exception as e:
		return HttpResponseBadRequest(str(e))


def login_view(request):
	# GET shows login form, POST authenticates existing pessoa
	if request.method == 'POST':
		nome = request.POST.get('nome')
		telefone = request.POST.get('telefone')
		if not (nome and telefone):
			return render(request, 'app_almoco/login.html', {'error': 'Nome e telefone são obrigatórios'})
		try:
			pessoa = Pessoa.objects.get(nome_completo=nome, telefone=telefone)
			request.session['pessoa_id'] = pessoa.pk
			request.session['pessoa_name'] = pessoa.nome_completo
			return redirect('app_almoco:index')
		except Pessoa.DoesNotExist:
			# redirect to signup page if not found
			return redirect('app_almoco:signup')

	return render(request, 'app_almoco/login.html')


def logout_view(request):
	request.session.pop('pessoa_id', None)
	request.session.pop('pessoa_name', None)
	return redirect('app_almoco:login')


def signup_view(request):
	# GET shows signup form, POST creates a new Pessoa and logs in
	if request.method == 'POST':
		nome = request.POST.get('nome')
		telefone = request.POST.get('telefone')
		if not (nome and telefone):
			return render(request, 'app_almoco/signup.html', {'error': 'Nome e telefone são obrigatórios'})
		pessoa, created = Pessoa.objects.get_or_create(nome_completo=nome, telefone=telefone)
		request.session['pessoa_id'] = pessoa.pk
		request.session['pessoa_name'] = pessoa.nome_completo
		return redirect('app_almoco:index')

	return render(request, 'app_almoco/signup.html')

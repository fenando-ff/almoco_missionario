from django.urls import path
from . import views

app_name = 'app_almoco'

urlpatterns = [
    path('', views.index, name='index'),
    path('api/save/', views.save_reservation, name='save_reservation'),
    path('api/delete/', views.delete_reservation, name='delete_reservation'),
    path('api/reservations/', views.get_reservations, name='get_reservations'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('signup/', views.signup_view, name='signup'),
]

from django.urls import path
from .views import (
    agents_list_json, agents_ppa_gat_pt_json, agents_naima_json,
    agents_by_fonction_json, agents_by_sheets_json, agents_by_airports_json,
    create_agent_api, update_agent_api, delete_agent_api, agents_stats_json,
    home_view, airport_detail_view
)

# API endpoints for different data views
urlpatterns = [
    # Home page
    path('', home_view, name='home'),
    path('airport/<str:airport_code>/', airport_detail_view, name='airport-detail'),

    # Read APIs
    path('mobile-api/agents/', agents_list_json, name='mobile-agents-all'),
    path('mobile-api/agents/stats/', agents_stats_json, name='mobile-agents-stats'),
    path('mobile-api/agents/ppa-gat-pt/', agents_ppa_gat_pt_json, name='mobile-agents-ppa-gat-pt'),
    path('mobile-api/agents/naima/', agents_naima_json, name='mobile-agents-naima'),
    path('mobile-api/agents/by-fonction/', agents_by_fonction_json, name='mobile-agents-by-fonction'),
    path('mobile-api/agents/by-sheets/', agents_by_sheets_json, name='mobile-agents-by-sheets'),
    path('mobile-api/agents/by-airports/', agents_by_airports_json, name='mobile-agents-by-airports'),

    # CRUD APIs
    path('mobile-api/agents/create/', create_agent_api, name='mobile-agents-create'),
    path('mobile-api/agents/update/<int:agent_id>/', update_agent_api, name='mobile-agents-update'),
    path('mobile-api/agents/delete/<int:agent_id>/', delete_agent_api, name='mobile-agents-delete'),
]

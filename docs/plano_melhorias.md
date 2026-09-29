# Plano de Melhorias — Sistema de Agendamento de Almoço

## Visão Geral do Sistema

**Nome:** Calendário de Almoço  
**Stack:** Django + vanilla JS + CSS puro (sem framework CSS)  
**Funcionalidade principal:** Agendamento de dias de almoço por usuários cadastrados  
**Páginas:** Login, Cadastro, Calendário mensal com navegação e exportação PDF  

---

## Análise Atual de Layout & Design

### Pontos Fortes Identificados
- Calendário responsivo com grid CSS nativo
- Navegação entre meses via API assíncrona
- Feedback visual de reserva com ícone Font Awesome
- Funcionalidade de exportação PDF
- Layout mobile-first com breakpoints bem definidos

### Problemas Identificados

#### 1. Inconsistências Responsivas
- `.container` define `max-width: 480px` (mobile), `900px` (desktop) e `1100px` (large desktop) — valores conflitantes sem lógica clara
- `.calendar` alterna entre `96%`, `85%`, `92%` e `100%` de largura nos breakpoints, causando desalinhamento com `.weekdays`
- No desktop large, `.month-nav` usa `justify-content: space-between` mas o título tem `flex: 1`, criando espaçamento excessivo

#### 2. Design & Hierarquia Visual
- Falta de hierarquia clara entre banner de boas-vindas, banner do usuário e calendário
- Paleta limitada a azul (#2b7cff) — sem cores semânticas para estados (sucesso, erro, aviso)
- Tipografia sem escala definida — tamanhos de fonte espalhados sem consistência
- Sem estados visuais de loading durante requisições assíncronas
- Feedback de erro via `alert()` — experiência UX ruim

#### 3. Acessibilidade
- Modais sem gerenciamento de foco (focus trap) nem suporte a ESC para fechar
- Sem skip link ou landmarks semânticos (`<main>`, `<nav>`, etc.)
- ARIA labels limitados — apenas no ícone de reserva
- Contraste de cores não verificado em textos sobre fundo azul

#### 4. Organização do Código
- CSS com regras duplicadas (ex: `.welcome-banner` definido duas vezes, `.day-block` repetido)
- Falta de convenção de nomenclatura consistente (BEM, utility classes, etc.)
- Arquivo único de CSS sem seções lógicas ou agrupamento por componente

#### 5. UX & Usabilidade
- Sem estado vazio guiado quando não há reservas no mês
- Sem notificações/toasts após ações (sucesso/erro)
- Input de telefone sem máscara visual (apenas formatação no backend)
- Sem legenda explicando ícones/estados do calendário
- Exportação PDF sem opções de configuração ou preview

---

## Plano de Melhorias

### Prioridade Alta

| # | Melhoria | Categoria | Impacto |
|---|----------|-----------|---------|
| 1 | **Unificar sistema de grid e larguras** | Layout | Alto |
| 2 | **Adicionar feedback visual de loading** | UX | Alto |
| 3 | **Substituir `alert()` por toasts** | UX | Alto |
| 4 | **Corrigir duplicações e organizar CSS** | Código | Médio |
| 5 | **Adicionar estados vazios** | UX | Médio |

### Prioridade Média

| # | Melhoria | Categoria | Impacto |
|---|----------|-----------|---------|
| 6 | **Melhorar acessibilidade de modais** | Acessibilidade | Médio |
| 7 | **Adicionar paleta de cores semântica** | Design | Médio |
| 8 | **Implementar máscara de telefone visual** | UX | Médio |
| 9 | **Adicionar legenda do calendário** | UX | Baixo |
| 10 | **Otimizar tipografia com escala modular** | Design | Médio |

### Prioridade Baixa / Futuro

| # | Melhoria | Categoria | Impacto |
|---|----------|-----------|---------|
| 11 | **Adicionar tema escuro (dark mode)** | Design | Baixo |
| 12 | **Implementar busca de reservas** | Funcionalidade | Baixo |
| 13 | **Adicionar preview antes de exportar PDF** | Funcionalidade | Baixo |
| 14 | **Migrar para CSS moderno com variáveis organizadas** | Código | Baixo |

---

## Detalhamento das Melhorias

### 1. Unificar Sistema de Grid e Larguras

**Problema:** `.container` e `.calendar` têm larguras conflitantes nos breakpoints.

**Solução:**
- Definir um sistema de escala de largura consistente:
  - Mobile: `--container-max: 100%`, `--calendar-width: 100%`
  - Tablet: `--container-max: 640px`, `--calendar-width: 100%`
  - Desktop: `--container-max: 960px`, `--calendar-width: 100%`
  - Large: `--container-max: 1200px`, `--calendar-width: 100%`
- Garantir que `.weekdays` e `.calendar` sempre tenham a mesma largura e gap
- Usar `box-sizing: border-box` globalmente e remover larguras em `%` que causam overflow

### 2. Adicionar Feedback Visual de Loading

**Problema:** Sem indicação visual durante carregamento de reservas ou ações de API.

**Solução:**
- Adicionar skeleton loader nos blocos de dia durante carregamento inicial
- Adicionar spinner nos botões de ação (Confirmar, Desmarcar, Exportar)
- Desabilitar botões durante requisições para evitar cliques duplicados

### 3. Substituir `alert()` por Toasts

**Problema:** `alert()` bloqueia a UI e não permite múltiplas mensagens.

**Solução:**
- Criar componente de toast notification no canto superior direito
- Tipos: `success`, `error`, `info`, `warning`
- Duração configurável (3s para sucesso, 5s para erro)
- Animação de entrada/saída suave
- Stack de toasts para mensagens múltiplas

### 4. Corrigir Duplicações e Organizar CSS

**Problema:** Regras CSS duplicadas e sem organização lógica.

**Solução:**
- Remover duplicações (ex: `.welcome-banner` aparece duas vezes, `.day-block` tem duas definições)
- Organizar CSS por seções:
  1. Variáveis e reset
  2. Layout base
  3. Componentes (calendar, modal, buttons)
  4. Breakpoints
- Adotar convenção de nomenclatura consistente (ex: BEM simplificado)
- Adicionar comentários de seção para facilitar manutenção

### 5. Adicionar Estados Vazios

**Problema:** Calendário vazio não guia o usuário.

**Solução:**
- Quando não há reservas no mês, exibir mensagem centralizada no calendário: "Nenhum almoço agendado. Clique em um dia para agendar."
- Quando o usuário não tem reservas, destacar dias disponíveis com estilo diferente
- Adicionar ilustração ou ícone no estado vazio

### 6. Melhorar Acessibilidade de Modais

**Problema:** Modais não têm focus trap, nem suporte a ESC, nem gerenciamento de foco.

**Solução:**
- Implementar focus trap nos modais (ciclo de tabulação restrito)
- Fechar modal com tecla ESC
- Retornar foco ao elemento que abriu o modal
- Adicionar `role="dialog"`, `aria-modal="true"`, `aria-labelledby`
- Garantir contraste mínimo de 4.5:1 para textos

### 7. Adicionar Paleta de Cores Semântica

**Problema:** Apenas azul como cor de destaque — sem indicação visual de estados.

**Solução:**
- Definir cores semânticas:
  - `--success`: verde para reservas confirmadas
  - `--error`: vermelho para ações de exclusão
  - `--warning`: amarelo para avisos
  - `--info`: azul claro para informações
  - `--disabled`: cinza para dias indisponíveis
- Aplicar cores em botões, badges e indicadores de status

### 8. Implementar Máscara de Telefone Visual

**Problema:** Input de telefone não tem formatação visual enquanto o usuário digita.

**Solução:**
- Adicionar máscara `(00) 00000-0000` no campo de telefone
- Usar plugin ou implementação vanilla com `input` event
- Validar formato em tempo real
- Manter formatação no backend para consistência

### 9. Adicionar Legenda do Calendário

**Problema:** Usuário pode não entender o ícone de talheres ou o significado das cores.

**Solução:**
- Adicionar legenda abaixo do calendário:
  - 🍽️ Dia reservado
  - Dia disponível
  - Dia atual (destaque especial)
- Manter legenda discreta mas visível

### 10. Otimizar Tipografia com Escala Modular

**Problema:** Tamanhos de fonte espalhados sem sistema.

**Solução:**
- Definir escala modular (ex: 0.75rem, 0.875rem, 1rem, 1.25rem, 1.5rem, 2rem)
- Usar `rem` para todos os tamanhos de fonte
- Definir line-heights consistentes (1.4 para body, 1.2 para títulos)
- Garantir legibilidade mínima de 16px no body

---

## Arquitetura de Design Proposta

```
Cores
├── Primária: #2b7cff (azul atual — manter)
├── Secundária: #f0f4ff (azul claro para backgrounds)
├── Sucesso: #22c55e
├── Erro: #ef4444
├── Aviso: #f59e0b
└── Neutras: escala de cinzas de #f8fafc a #0f172a

Tipografia
├── Família: system-ui (manter)
├── Escala: modular com base 1rem = 16px
└── Pesos: 400 (regular), 500 (medium), 600 (semibold), 700 (bold)

Espaçamento
├── Unidade base: 4px
├── Escala: 4, 8, 12, 16, 20, 24, 32, 48, 64px
└── Grid: 8px (gaps e paddings)

Breakpoints
├── Mobile: 0 - 519px
├── Tablet: 520px - 1023px
├── Desktop: 1024px - 1279px
└── Large: 1280px+
```

---

## Estimativa de Esforço

| Categoria | Complexidade | Tempo Estimado |
|-----------|--------------|----------------|
| Layout & Responsividade | Média | 4-6h |
| UX (toasts, loading, estados vazios) | Média | 3-4h |
| Acessibilidade | Média | 2-3h |
| Organização de CSS | Baixa | 2h |
| Funcionalidades (máscara, legenda) | Baixa | 1-2h |
| **Total** | | **12-17h** |

---

## Próximos Passos

1. **Fase 1 (Quick Wins):** Organizar CSS, remover duplicações, substituir `alert()` por toasts
2. **Fase 2 (Layout):** Unificar grid e larguras, corrigir alinhamento de weekday/calendar
3. **Fase 3 (UX):** Adicionar loading states, estados vazios, máscara de telefone
4. **Fase 4 (Acessibilidade):** Melhorar modais, adicionar ARIA, verificar contraste
5. **Fase 5 (Polimento):** Paleta semântica, tipografia, legenda, tema escuro

---

*Documento gerado em: 2026-09-29*  
*Autor: Análise de layout e design do sistema*

# Plano: login biométrico em dispositivos móveis

## Objetivo

Permitir que uma pessoa entre na própria conta usando a biometria já configurada no celular, sem exigir o cadastro dessa opção durante a criação da conta. A pessoa poderá ativá-la depois, já autenticada.

## Abordagem técnica

Implementar passkeys com WebAuthn. O navegador solicita ao autenticador do dispositivo uma verificação local, que pode usar impressão digital, reconhecimento facial, PIN ou o método configurado pela pessoa. A biometria e seus dados não são enviados nem armazenados pelo site. O servidor guarda somente a credencial WebAuthn, incluindo identificador e chave pública, associada à conta `Pessoa`.

O fluxo exige HTTPS em produção (localhost é permitido para desenvolvimento), navegador e autenticador compatíveis e uma ação explícita da pessoa. A interface deve explicar que o método exibido depende do dispositivo, sem prometer que sempre será uma biometria.

## Pré-requisito de segurança

Antes de permitir vincular uma credencial, confirmar que a pessoa controla a conta. Hoje, o login e o cadastro usam apenas nome e telefone, e o cadastro cria uma sessão imediatamente. Esses dados não comprovam a posse da conta. Implementar verificação do telefone por código de uso único, ou outro processo confiável, antes do primeiro vínculo e da recuperação. Não usar apenas a sessão criada pelo formulário atual como autorização suficiente para registrar uma passkey.

## Etapas de implementação

1. **Definir biblioteca e compatibilidade**
	- Avaliar uma biblioteca WebAuthn mantida para Python/Django, cobrindo geração e validação de desafios e verificação de origem, RP ID e resposta.
	- Confirmar domínio de produção, HTTPS, navegadores móveis suportados e política de recuperação antes de fixar a configuração WebAuthn.

2. **Persistir credenciais**
	- Criar modelo de credencial relacionado a `Pessoa`, com identificador único, chave pública, contador de uso, metadados úteis (nome amigável do dispositivo e datas de criação/uso) e estado ativo/revogado.
	- Permitir mais de uma credencial por pessoa para suportar vários dispositivos e facilitar a recuperação.
	- Criar e aplicar migração sem alterar o vínculo existente de reservas.

3. **Registrar uma passkey**
	- Oferecer a opção após o cadastro, sem torná-la obrigatória, e também numa área de conta para quem decidir adicioná-la posteriormente.
	- Exigir sessão autenticada e confirmação recente da identidade/posse do telefone.
	- Criar um desafio de registro aleatório, temporário e de uso único no servidor; solicitar a criação da credencial pelo navegador; validar a resposta no servidor e então associá-la à `Pessoa` autenticada.
	- Permitir cancelar sem bloquear o cadastro ou o uso normal da conta.

4. **Entrar com passkey**
	- Incluir no login uma ação para usar passkey. Oferecer seleção de conta/telefone ou login sem nome de usuário, conforme o suporte dos navegadores e a estratégia adotada para credenciais descobríveis.
	- Criar desafio temporário de autenticação no servidor e validar a resposta WebAuthn, incluindo desafio, origem, RP ID, assinatura e credencial ativa.
	- Só após validação estabelecer a sessão Django existente (`pessoa_id` e `pessoa_name`), renovando a chave da sessão. Respostas inválidas, expiradas ou reutilizadas não podem autenticar.

5. **Administrar e recuperar**
	- Permitir listar e revogar passkeys da própria conta, identificando-as por nome e data; impedir que a pessoa remova a última opção de acesso sem cadastrar outra ou confirmar recuperação.
	- Manter um fluxo de recuperação independente da passkey, baseado em identidade verificada. Não remover o login atual até haver um substituto seguro; revisar nome + telefone como fallback, pois não são segredo nem prova de posse.
	- Registrar eventos de cadastro, uso e revogação sem guardar dados biométricos ou respostas sensíveis desnecessárias.

6. **Proteger endpoints e implantação**
	- Exigir POST e proteção CSRF nas operações iniciadas pela sessão; aplicar limites de tentativas e desafios de curta duração, vinculados à sessão/contexto e consumidos uma única vez.
	- Não confiar em identificadores ou dados de conta enviados pelo cliente para decidir a qual `Pessoa` vincular a credencial.
	- Configurar origem e RP ID apenas para os domínios oficiais; validar HTTPS e configurações seguras de cookies/sessão em produção.

7. **Testar e liberar gradualmente**
	- Testar cadastro opcional e posterior, login válido, desafio expirado/reutilizado, credencial inválida ou revogada, origem/RP ID incorretos, cancelamento, múltiplos dispositivos, recuperação e ausência de suporte no navegador.
	- Testar em navegadores atuais de Android e iOS, além de desktop, e verificar que o fluxo tradicional continua disponível durante a adoção.
	- Liberar primeiro como opção, monitorar falhas sem registrar segredos e só então avaliar torná-la o caminho recomendado.

## Critérios de conclusão

- Uma pessoa pode criar conta sem passkey e adicioná-la posteriormente após comprovar o controle da conta.
- Uma passkey válida autentica somente a `Pessoa` à qual foi vinculada; credenciais inválidas, revogadas ou desafios repetidos não criam sessão.
- Nenhum dado biométrico é transmitido ou armazenado pelo sistema.
- Há alternativa de acesso e recuperação, e a interface explica quando o dispositivo/navegador não oferece suporte.

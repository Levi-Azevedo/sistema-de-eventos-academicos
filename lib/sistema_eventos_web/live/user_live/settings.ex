defmodule SistemaEventosWeb.UserLive.Settings do
  use SistemaEventosWeb, :live_view

  on_mount {SistemaEventosWeb.UserAuth, :require_sudo_mode}

  alias SistemaEventos.Accounts

@impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <%!-- Fundo principal da página Settings --%>
      <div class="min-h-[80vh] bg-slate-950 px-4 py-10 sm:px-6 lg:px-8 rounded-3xl shadow-2xl mt-4">
        
        <div class="text-center mb-12">
          <.header>
            <span class="text-4xl font-extrabold text-white tracking-tight">Configurações da Conta</span>
            <:subtitle><span class="text-slate-400">Gerencie seu perfil, e-mail e senha de acesso.</span></:subtitle>
          </.header>
        </div>

        <%!-- GRID: 1 coluna no celular, 3 colunas no PC --%>
        <div class="mx-auto max-w-7xl grid grid-cols-1 gap-8 lg:grid-cols-3">

          <div class="bg-slate-900 border border-slate-800 rounded-3xl p-8 shadow-xl flex flex-col">
            <h2 class="text-xl font-bold text-white mb-6">Informações Pessoais</h2>
            
            <.form for={@profile_form} id="profile_form" phx-submit="update_profile" phx-change="validate_profile" class="space-y-6 flex-1 flex flex-col justify-between">
              <div class="space-y-4">
                <.input field={@profile_form[:nome]} type="text" label="Nome Completo" required />
                <.input field={@profile_form[:matricula]} type="text" label="Matrícula Acadêmica" />
              </div>
              
              <.button phx-disable-with="Salvando..." class="w-full mt-6 bg-blue-600 hover:bg-blue-500 text-white font-bold py-3 rounded-xl shadow-lg cursor-pointer transition-transform transform hover:scale-[1.02]">
                Salvar Informações
              </.button>
            </.form>
          </div>

          <div class="bg-slate-900 border border-slate-800 rounded-3xl p-8 shadow-xl flex flex-col">
            <h2 class="text-xl font-bold text-white mb-6">E-mail Autenticado</h2>
            
            <.form for={@email_form} id="email_form" phx-submit="update_email" phx-change="validate_email" class="space-y-6 flex-1 flex flex-col justify-between">
              <div class="space-y-4">
                <.input field={@email_form[:email]} type="email" label="Novo E-mail" autocomplete="username" spellcheck="false" required />
              </div>
              
              <.button phx-disable-with="Mudando..." class="w-full mt-6 bg-slate-800 hover:bg-slate-700 border border-slate-700 text-white font-bold py-3 rounded-xl cursor-pointer transition-transform transform hover:scale-[1.02]">
                Mudar E-mail
              </.button>
            </.form>
          </div>


          <div class="bg-slate-900 border border-slate-800 rounded-3xl p-8 shadow-xl flex flex-col">
            <h2 class="text-xl font-bold text-white mb-6">Segurança</h2>
            
            <.form for={@password_form} id="password_form" action={~p"/users/update-password"} method="post" phx-change="validate_password" phx-submit="update_password" phx-trigger-action={@trigger_submit} class="space-y-6 flex-1 flex flex-col justify-between">
              <input name={@password_form[:email].name} type="hidden" id="hidden_user_email" spellcheck="false" value={@current_email} />
              
              <div class="space-y-4">
                <.input field={@password_form[:password]} type="password" label="Nova senha" autocomplete="new-password" spellcheck="false" required />
                <.input field={@password_form[:password_confirmation]} type="password" label="Confirmar nova senha" autocomplete="new-password" spellcheck="false" />
              </div>
              
              <.button phx-disable-with="Salvando..." class="w-full mt-6 bg-slate-800 hover:bg-slate-700 border border-slate-700 text-white font-bold py-3 rounded-xl cursor-pointer transition-transform transform hover:scale-[1.02]">
                Salvar Senha
              </.button>
            </.form>
          </div>

        </div>
      </div>
    </Layouts.app>
    """
  end
  @impl true
  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_scope.user, token) do
        {:ok, _user} ->
          put_flash(socket, :info, "Email mudado com sucesso.")

        {:error, _} ->
          put_flash(socket, :error, "Link de mudança de emial inválido ou expirado.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user
    email_changeset = Accounts.change_user_email(user, %{}, validate_unique: false)
    password_changeset = Accounts.change_user_password(user, %{}, hash_password: false)

    socket =
      socket
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)
      |> assign(:profile_form, to_form(Accounts.change_user_profile(user)))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate_email", params, socket) do
    %{"user" => user_params} = params

    email_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_email(user_params, validate_unique: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form)}
  end

  def handle_event("update_email", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user
    true = Accounts.sudo_mode?(user)

    case Accounts.change_user_email(user, user_params) do
      %{valid?: true} = changeset ->
        Accounts.deliver_user_update_email_instructions(
          Ecto.Changeset.apply_action!(changeset, :insert),
          user.email,
          &url(~p"/users/settings/confirm-email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info)}

      changeset ->
        {:noreply, assign(socket, :email_form, to_form(changeset, action: :insert))}
    end
  end

  @impl true
  def handle_event("validate_profile", %{"user" => user_params}, socket) do
    profile_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_profile(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, profile_form: profile_form)}
  end

 @impl true
  def handle_event("update_profile", %{"user" => user_params}, socket) do
    user = socket.assigns.current_scope.user

    case Accounts.update_user_profile(user, user_params) do
      {:ok, updated_user} ->
        profile_form = to_form(Accounts.change_user_profile(updated_user))

        new_scope = %{socket.assigns.current_scope | user: updated_user}

        {:noreply,
         socket
         |> assign(:current_scope, new_scope)
         |> assign(:profile_form, profile_form)
         |> put_flash(:info, "Perfil atualizado com sucesso!")}

      {:error, changeset} ->
        {:noreply, assign(socket, :profile_form, to_form(changeset))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"user" => user_params} = params

    password_form =
      socket.assigns.current_scope.user
      |> Accounts.change_user_password(user_params, hash_password: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form)}
  end

  def handle_event("update_password", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_scope.user
    true = Accounts.sudo_mode?(user)

    case Accounts.change_user_password(user, user_params) do
      %{valid?: true} = changeset ->
        {:noreply, assign(socket, trigger_submit: true, password_form: to_form(changeset))}

      changeset ->
        {:noreply, assign(socket, password_form: to_form(changeset, action: :insert))}
    end
  end
end

defmodule SistemaEventosWeb.UserLive.Registration do
  use SistemaEventosWeb, :live_view

  alias SistemaEventos.Accounts
  alias SistemaEventos.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="min-h-[80vh] flex flex-col justify-center bg-slate-950 py-12 sm:px-6 lg:px-8 rounded-3xl shadow-2xl mt-4">
        <div class="sm:mx-auto sm:w-full sm:max-w-md space-y-4">
          
          <div class="text-center">
            <.header >
              <span class="text-4xl font-extrabold text-white tracking-tight">Crie sua conta</span>
              <:subtitle>
                <span class="text-slate-400">Já tem cadastro?</span>
                <.link navigate={~p"/users/log-in"} class="font-semibold text-blue-500 hover:text-blue-400 transition-colors cursor-pointer">
                  Faça login aqui
                </.link>
              </:subtitle>
            </.header>
          </div>

          <div class="bg-slate-900 border border-slate-800 py-8 px-4 shadow-2xl sm:rounded-2xl sm:px-10 mt-8">
            
            
            <div class="mb-6">
              <.link navigate={~p"/events"}>
                <.button type="button" class="w-full bg-slate-800 hover:bg-slate-700 border border-slate-700 text-white font-semibold py-3 rounded-xl transition-colors cursor-pointer flex justify-center items-center gap-2">
                  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 9v7.5m-9-6h.008v.008H12v-.008ZM12 15h.008v.008H12V15Zm0 2.25h.008v.008H12v-.008ZM9.75 15h.008v.008H9.75V15Zm0 2.25h.008v.008H9.75v-.008ZM7.5 15h.008v.008H7.5V15Zm0 2.25h.008v.008H7.5v-.008Zm6.75-4.5h.008v.008h-.008v-.008Zm0 2.25h.008v.008h-.008V15Zm0 2.25h.008v.008h-.008v-.008Zm2.25-4.5h.008v.008H16.5v-.008Zm0 2.25h.008v.008H16.5V15Z" />
                  </svg>
                  Explorar Eventos Disponíveis
                </.button>
              </.link>
            </div>

            
            <div class="relative my-8">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-slate-800"></div>
              </div>
              <div class="relative flex justify-center text-sm">
                <span class="bg-slate-900 px-4 text-slate-500 font-medium">Ou preencha seus dados</span>
              </div>
            </div>

            
            <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate" class="space-y-5">

              <%!-- CAMPOS NOVOS OBRIGATÓRIOS --%>
              <.input field={@form[:nome]} type="text" label="Nome Completo" required phx-mounted={JS.focus()} />
              <.input field={@form[:matricula]} type="text" label="Matrícula Acadêmica" required />
              
              
              <.input 
                field={@form[:role]}
                type="select"
                label="Eu sou..."
                options={[{"Aluno", "aluno"}, {"Palestrante", "palestrante"}]}
                required
              />

              
              <.input field={@form[:email]} type="email" label="Email" autocomplete="username" spellcheck="false" required />
              <.input field={@form[:password]} type="password" label="Senha" required />

              <div class="pt-2">
                <.button phx-disable-with="Criando conta..." class="w-full bg-blue-600 hover:bg-blue-500 text-white font-bold py-3 rounded-xl shadow-lg cursor-pointer transition-transform transform hover:scale-[1.02]">
                  Criar uma Conta <span aria-hidden="true" class="ml-2">→</span>
                </.button>
              </div>
            </.form>

          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: SistemaEventosWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{role: "aluno"})

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/users/log-in/#{&1}")
          )

        {:noreply,
         socket
         |> put_flash(
           :info,
           "UM email foi enviado para #{user.email}, porfavor, acesse para confirmar sua conta!!!!!!."
         )
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = 
      %User{}
      |> Accounts.change_user_registration(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end

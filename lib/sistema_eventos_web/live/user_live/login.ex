defmodule SistemaEventosWeb.UserLive.Login do
  use SistemaEventosWeb, :live_view

  alias SistemaEventos.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <%!-- Fundo escuro cobrindo a área central --%>
      <div class="min-h-[80vh] flex flex-col justify-center bg-slate-950 py-12 sm:px-6 lg:px-8 rounded-3xl shadow-2xl">
        <div class="sm:mx-auto sm:w-full sm:max-w-md space-y-4">
          
          <div class="text-center">
            <.header>
              <p class="text-4xl font-extrabold text-white tracking-tight">Bem-vindo de volta</p>
              <:subtitle>
                <%= if @current_scope do %>
                  <span class="text-slate-400">Você precisa se reautenticar para acessar áreas sensíveis.</span>
                <% else %>
                  <span class="text-slate-400">Ainda não tem uma conta?</span>
                  <.link
                    navigate={~p"/users/register"}
                    class="font-semibold text-blue-500 hover:text-blue-400 transition-colors cursor-pointer"
                    phx-no-format
                  >Cadastre-se aqui</.link>
                <% end %>
              </:subtitle>
            </.header>
          </div>

          <%!-- Alerta do E-mail (estilizado para Dark Mode) --%>
          <div :if={local_mail_adapter?()} class="alert alert-info bg-blue-900/50 border border-blue-800 text-blue-200 mt-4 rounded-xl">
            <.icon name="hero-information-circle" class="size-6 shrink-0 text-blue-400" />
            <div>
              <p>Rodando o adaptador de e-mail local.</p>
              <p>
                Para ver os e-mails, acesse <.link href="/dev/mailbox" class="underline text-blue-300 hover:text-blue-200 cursor-pointer">a caixa de entrada</.link>.
              </p>
            </div>
          </div>

          <%!-- Card Principal do Formulário --%>
          <div class="bg-slate-900 border border-slate-800 py-8 px-4 shadow-2xl sm:rounded-2xl sm:px-10 mt-8">
            
            <%!-- Formulário 1: Link Mágico --%>
            <.form

            
              :let={f}
              for={@form}
              id="login_form_magic"
              action={~p"/users/log-in"}
              phx-submit="submit_magic"
            >
              <.input
                readonly={!!@current_scope}
                field={f[:email]}
                type="email"
                label="Email"
                autocomplete="username"
                spellcheck="false"
                required
                phx-mounted={JS.focus()}
              />
              <.button class="w-full mt-5 bg-blue-600 hover:bg-blue-500 text-white font-bold py-3 rounded-xl shadow-lg cursor-pointer transition-transform transform hover:scale-[1.02]">
                Entrar com Link Mágico <span aria-hidden="true" class="ml-2">→</span>
              </.button>
            </.form>

            <%!-- Divisor customizado --%>
            <div class="relative my-8">
              <div class="absolute inset-0 flex items-center">
                <div class="w-full border-t border-slate-700"></div>
              </div>
              <div class="relative flex justify-center text-sm">
                <span class="bg-slate-900 px-4 text-slate-500 font-semibold">ou com senha</span>
              </div>
            </div>

            <%!-- Formulário 2: Senha Tradicional --%>
            <.form
              :let={f}
              for={@form}
              id="login_form_password"
              action={~p"/users/log-in"}
              phx-submit="submit_password"
              phx-trigger-action={@trigger_submit}
              class="space-y-5"
            >
              <.input
                readonly={!!@current_scope}
                field={f[:email]}
                type="email"
                label="Email"
                autocomplete="username"
                spellcheck="false"
                required
              />
              <.input
                field={@form[:password]}
                type="password"
                label="Senha"
                autocomplete="current-password"
                spellcheck="false"
              />
              
              <div class="pt-2">
                <.button class="w-full bg-slate-800 hover:bg-slate-700 text-white font-bold py-3 rounded-xl shadow cursor-pointer transition-transform transform hover:scale-[1.02]" name={@form[:remember_me].name} value="true">
                  Entrar e continuar logado
                </.button>
                <.button class="w-full mt-3 bg-transparent border border-slate-700 hover:bg-slate-800 text-slate-400 font-semibold py-3 rounded-xl cursor-pointer transition-colors">
                  Entrar apenas desta vez
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
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_login_instructions(
        user,
        &url(~p"/users/log-in/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions for logging in shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:sistema_eventos, SistemaEventos.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
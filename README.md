# stimulus-password-strength

Importmap-friendly password strength field for Rails 8+ with Stimulus, zxcvbn and Tailwind.

## Cel produktu

Zmniejszyć porzucenia na rejestracji przez lepszy UX hasła:
- jedno pole hasła + `show/hide`
- real-time strength meter
- requirements widoczne nad inputem, żeby nie były zasłaniane przez 1Password/LastPass
- brak zależności od Node.js
- możliwie najprostsza rejestracja przy zachowaniu standardów bezpieczeństwa i UX best practices

## Co zawiera gem

- Rails Engine (`StimulusPasswordStrength::Engine`)
- Stimulus controller: `password-strength`
- vendored `zxcvbn.js`
- helper `password_strength_field`
- partial `_field.html.erb`
- installer `rails g stimulus_password_strength:install`
- domyślne i18n (`en`, `pl`)

## Instalacja

Dodaj do `Gemfile` aplikacji:

```ruby
gem "stimulus-password-strength"
```

Następnie:

```bash
bundle install
bin/rails generate stimulus_password_strength:install
```

Installer:
- dodaje piny do `config/importmap.rb`
- rejestruje controller w `app/javascript/controllers/index.js`
- tworzy initializer `config/initializers/stimulus_password_strength.rb`
- tworzy `app/lib/password_policy.rb` jako jedno źródło prawdy dla reguł pokazywanych w UI

## Użycie

```erb
<%= form_with(model: @user) do |form| %>
  <%= password_strength_field form, :password,
      placeholder: "Minimum 12 characters",
      requirements: PasswordPolicy.requirements %>
<% end %>
```

Z custom labelami:

```erb
<%= password_strength_field form, :password,
    strength_labels: { weak: "Słabe", fair: "Przeciętne", good: "Dobre", strong: "Silne" },
    toggle_labels: { show: "Pokaż", hide: "Ukryj" } %>
```

## Password Policy

Installer dodaje przykładowy plik [app/lib/password_policy.rb](/Users/justi/projects_prod/stimulus-password-strength/lib/generators/stimulus_password_strength/install/templates/password_policy.rb.tt), który powinien być wspólnym źródłem prawdy dla:
- walidacji modelu
- wymagań pokazywanych przez gem

Przykład użycia w host-app:

```ruby
# app/models/user.rb
validates :password, length: { minimum: PasswordPolicy::MIN_LENGTH }, allow_nil: true
```

```erb
<%= password_strength_field form, :password,
    requirements: PasswordPolicy.requirements %>
```

`min_length` can use dynamic live copy from `PasswordPolicy`, for example:

```ruby
REQUIREMENTS = [
  {
    rule: :min_length,
    value: MIN_LENGTH,
    label: "At least #{MIN_LENGTH} characters",
    remaining_singular: "Type 1 more character",
    remaining_plural: "Type %{count} more characters",
    met_label: "#{MIN_LENGTH}+ chars"
  }
].freeze
```

Gem nie próbuje inferować reguł z modelu i nie dodaje fallbacków dla `requirements`. To host-app jawnie przekazuje politykę z `PasswordPolicy`.

## Konfiguracja

`config/initializers/stimulus_password_strength.rb`:

```ruby
StimulusPasswordStrength.configure do |config|
  config.input_class = "w-full rounded-md border px-3 py-2 pr-16"
  config.text_style = "min-width: 2.5rem; text-align: right; white-space: nowrap;"
  config.status_row_class = "flex min-h-5 items-center gap-2"
  config.requirements_style = "min-height: 1rem;"
  config.requirement_pending_style = "color: #6b7280;"
  config.requirement_met_style = "color: #047857;"
  config.requirement_unmet_style = "color: #b91c1c;"

  config.bar_colors = {
    weak: "#f87171",
    fair: "#fbbf24",
    good: "#22c55e",
    strong: "#059669"
  }
end
```

Rozszerzanie na nowe języki opiera się na Rails I18n: dodaj kolejny plik locale w katalogu [config/locales](/Users/justi/projects_prod/stimulus-password-strength/config/locales).

## Co testować po integracji (checklista)

1. Rejestracja: słabe hasło -> walidacja backendu nadal działa.
2. Rejestracja: `requirements` pokrywają się z `PasswordPolicy` i z walidacją modelu.
3. Rejestracja: toggle `Show/Hide` działa na mobile i desktop.
4. Reset hasła: meter, requirements i toggle działają identycznie jak przy signup.
5. Autofill hasła: strength meter i requirements odświeżają się poprawnie.
6. Brak JS/zxcvbn error: formularz nadal pozwala wysłać hasło.
7. i18n: labelki (`show/hide/weak/fair/good/strong`) są poprawne dla locale.

## Best Practices Dla Agenta Instalującego Gem

Traktuj ten gem jako warstwę UI, nie jako politykę bezpieczeństwa haseł.

### Cel instalacji

Masz poprawić UX pola hasła i zmniejszyć tarcie przy rejestracji:
- meter ma być widoczny bez kolizji z password managerami
- toggle ma być intuicyjny i dostępny
- host-app ma zachować własne walidacje backendowe, dopóki ktoś świadomie ich nie zmieni

### Procedura wdrożenia

1. Dodaj gem do `Gemfile` i uruchom:

```bash
bundle install
bin/rails generate stimulus_password_strength:install
```

2. Użyj wygenerowanego `PasswordPolicy` jako źródła prawdy dla reguł backendu i UI.
3. Podmień tylko główne pole hasła na `password_strength_field`, przekazując `requirements: PasswordPolicy.requirements`.
4. Zaktualizuj wszystkie user-facing widoki z polem hasła. Minimum:
   - `signup / registration`
   - `password reset / change password`
5. Jeśli projekt ma dodatkowe flow ustawiania hasła, zaktualizuj również je:
   - invitation acceptance
   - onboarding set password
   - admin-created account activation
   - forced password change
6. Nie usuwaj `password_confirmation`, jeśli host-app nadal go wymaga.
7. Nie zmieniaj backendowych walidacji hasła przy pierwszym rolloutcie, jeśli nie przepiąłeś ich na `PasswordPolicy`.
8. Najpierw zrób rollout UI-only, dopiero potem rozważ zmianę polityki haseł.

### Czego agent musi dopilnować w host-app

1. Sprawdź model użytkownika i kontrolery auth:
   - czy aplikacja wymaga `password_confirmation`
   - czy aplikacja wymaga regexów typu uppercase/lowercase/digit
   - czy istnieją niestandardowe komunikaty błędów
2. Przepnij minimalnie jedną regułę z modelu do `PasswordPolicy`, zanim pokażesz `requirements` userowi.
3. Usuń lub zaktualizuj copy, które obiecuje zasady inne niż faktycznie egzekwuje backend.
4. Jeśli używasz custom label row nad inputem, zostaw stałą szerokość tekstu statusu albo prawy alignment, żeby layout nie "pływał".
5. Jeśli host-app ma własny design system, przekazuj własne klasy do helpera zamiast forka gema.

### Czego agent nie powinien robić automatycznie

1. Nie usuwaj `password_confirmation`, jeśli nie przejrzałeś walidacji, testów i flow resetu hasła.
2. Nie zmieniaj polityki haseł tylko dlatego, że meter pokazuje `good` lub `strong`.
3. Nie definiuj `requirements` niezależnie od `PasswordPolicy`, bo rozjedziesz UI z backendem.
4. Nie hardcoduj hintów typu `Must contain uppercase...`, jeśli to nie zgadza się z backendem.
5. Nie zakładaj, że Tailwindowe klasy dynamicznie ustawiane z JS będą działały w każdej host-app.

### Minimalny smoke test po instalacji

1. Signup: wpisz słabe hasło, sprawdź meter, toggle i komunikat backendu.
2. Signup z włączonym 1Password/LastPass: upewnij się, że meter nie jest zasłonięty.
3. Reset hasła: sprawdź ten sam komponent w drugim flow.
4. Autofill przeglądarki: upewnij się, że po wpisaniu lub autofillu meter się aktualizuje.
5. Mobile viewport: toggle nie może nachodzić na tekst ani na ikonki managera haseł.

### Kiedy dopiero zmieniać politykę haseł

Zmieniaj backend dopiero po osobnej decyzji produktowej. Ten gem nie zastępuje:
- walidacji modelu
- rate limiting
- anty-abuse
- kontroli resetu hasła

## linked_flow: zakres adaptacji

Dla `../linked_flow` gem został już użyty jako przykład pełnego uproszczenia UX:
- signup i reset hasła działają bez `password_confirmation`
- UI używa `password_strength_field`
- backend i UI używają wspólnego `PasswordPolicy` z minimalną długością hasła

Dlatego rekomendowany rollout:
1. Podpiąć gem tylko jako UI (bez zmiany backend policy).
2. Przepiąć widoki signup/reset na `password_strength_field`.
3. Dopiero potem ewentualnie upraszczać backend i testy biznesowe.

## Co jeszcze warto dorobić po `0.1.0`

1. Generator do scaffoldu testów JS w aplikacji hosta.
2. CI matrix rozszerzony o Rails `8.0` i `8.1`.
3. Opcja `confirmation: true/false` w helperze.
4. Publiczna dokumentacja eventów analitycznych (retention funnel).
5. Szersze przykłady integracji z design systemami host-app.

## Development

```bash
cd /Users/justi/projects_prod/stimulus-password-strength
bundle install
npm install
bundle exec rake test
npm test
```

## Release hygiene

- pełny checklist publikacyjny: [PUBLISH_CHECKLIST.md](PUBLISH_CHECKLIST.md)
- historia zmian: [CHANGELOG.md](CHANGELOG.md)

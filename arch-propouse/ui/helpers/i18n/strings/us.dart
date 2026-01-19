import './translation.dart';

class Us implements Translation {
  // ACCOUNT
  @override
  String get login => 'Login';
  @override
  String get confirmEmail => 'Confirme seu email';
  @override
  String get email => 'Email';
  @override
  String get token => 'Token';
  @override
  String get accept => 'Aceitar';
  @override
  String get reload => 'Reload';
  @override
  String get baseCode => 'Código de base';
  @override
  String get register => 'Cadastro';
  @override
  String get enterYourDetails => 'Dados Principais';
  @override
  String get setAPassword => 'Defina uma senha';
  @override
  String get password => 'Senha';
  @override
  String get confirmPassword => 'Confirmar senha';
  @override
  String get noAccount => 'Não tem conta?';
  @override
  String get registerNow => 'Cadastre-se agora';
  @override
  String get previousPassword => 'Senha anterior';
  @override
  String get updatedPassword => 'Senha atualizada';
  @override
  String get passwordUpdatedSuccessfully =>
      'Sua senha foi atualizada com sucesso.';
  @override
  String get passwordNotMatch => 'As senhas não coincidem.';
  @override
  String get codeBaseInvalid => 'Código da base inválido.';
  @override
  String get incorrectPassword => 'Senha inválida';
  @override
  String get whatIsYourEmail => 'Qual seu e-mail?';
  @override
  String get whatIsYourPhone => 'Qual seu celular?';
  @override
  String get createPassword => 'Crie uma senha';
  @override
  String get yourPassword => 'Sua senha';

  // MESSAGES
  @override
  String get msgEmailInUse => 'O e-mail já está em uso.';
  @override
  String get msgInvalidCredentials =>
      'E-mail ou senha incorretos. Por favor, tente novamente.';
  @override
  String get msgInvalidField => 'E-mail inválido';
  @override
  String get msgRequiredField => 'Campo obrigatório';
  @override
  String get msgUnexpectedError =>
      'Falha ao carregar informações. Por favor, tente novamente em breve.';
  @override
  String get have8Characters =>
      'Sua senha deve possuir no mínimo 8 caracteres.';
  @override
  String get savedChanges => 'Alterações salvas';
  @override
  String get updatedSuccessfully =>
      'Suas alterações foram atualizados com sucesso.';
  @override
  String get wantToReport => 'Deseja denunciar?';
  @override
  String get wantToReportSubtitle =>
      'Tem certeza que deseja denunciar  a publicação?';
  @override
  String get report => 'Denunciar';
  @override
  String get createPasswordMessage =>
      'Precisamos criar uma senha para o seu acesso.';
  @override
  String get minimumCharacters =>
      'Mínimo de 6 caracteres: use letras e números';

  //BUTTON
  @override
  String get close => 'Fechar';
  @override
  String get next => 'Próximo';
  @override
  String get save => 'Salvar';
  @override
  String get share => 'Share';
  @override
  String get cancel => 'Cancelar';
  @override
  String get logout => 'Deslogar do aplicativo';
  @override
  String get deleteAccount => 'Excluir conta';
  @override
  String get yes => 'Sim';
  @override
  String get proceed => 'Continuar';
  @override
  String get finalizeRegistration => 'Finalizar';
  @override
  String get seeAllMembers => 'Ver todos os membros';
  @override
  String get backLabel => 'Anterior';
  @override
  String get editProfile => 'Editar perfil';
  @override
  String get changePhoto => 'Alterar foto';
  @override
  String get saveEditions => 'Salvar alterações';
  @override
  String get link => 'link';
  @override
  String get openLink => 'Abrir link';
  @override
  String get uploadPhotoButton => 'Carregar Anexo';
  @override
  String get publishContent => 'Publicar conteúdo';
  @override
  String get openPdf => 'Abrir Pdf';
  @override
  String get continueLabel => 'Continue';
  @override
  String get createAccount => 'Criar Conta';
  @override
  String get forgotPassword => 'Esqueceu sua senha?';

  // SHARED
  @override
  String get foxErrors => 'Corrigir erros';
  @override
  String get navigationTitle => 'Welcome';
  @override
  String get sendFeedback => 'Send feedback';
  @override
  String get noConnectionsAvailable => '';

  //PAGES
  @override
  String get nutrition => 'Nutrição';
  @override
  String get profile => 'Perfil';
  @override
  String get personalData => 'Dados pessoais';
  @override
  String get wanToDeleteAccount => 'Deseja excluir sua conta?';
  @override
  String get confirmAccountDeletion =>
      'Confirme a exclusão de sua conta no aplicativo.';
  @override
  String get enterBase => 'Agora, digite sua base';
  @override
  String get name => 'Nome';
  @override
  String get phone => 'Telefone';
  @override
  String get gender => 'Sexo';
  @override
  String get relationship => 'Relacionamento';
  @override
  String get anErrorHasOccurred => 'Ocorreu um erro';
  @override
  String get youAreOffline => 'It looks like you are offline';
  @override
  String get checkInternetAccess => 'Check if the device has internet access';
  @override
  String get successTitle => 'Success';
  @override
  String get notificationTitle => 'Notificações';
  @override
  String get markReadNotification => 'Marcar como lidas';
  @override
  String get newMission => 'Nova missão';
  @override
  String get newMissionAvailable =>
      'Você possui uma nova missão disponível. Clique para conferir.';
  @override
  String get notificationInputTitle => 'Você ainda não possui notificações';
  @override
  String get notificationInputSubtitle =>
      'Quando você tiver notificações, elas irão aparecer aqui';
  @override
  String get missionTitle => 'Missões';
  @override
  String get yourMissions => 'Suas missões';
  @override
  String get levelLabel => 'Nível';
  @override
  String get dataLabel => 'Data';
  @override
  String get statusLabel => 'Status';
  @override
  String get baseMembers => 'Membros da sua base';
  @override
  String get myProfile => 'Meu Perfil';
  @override
  String get baseMembersTitle => 'Membros da base';
  @override
  String get deleteLabel => 'Excluir';
  @override
  String get searchbase => 'Digite o que você procura';
  @override
  String get logOffAccount => 'Sair da conta';
  @override
  String get messageLogOffAcount =>
      'Tem certeza de que deseja sair da sua conta?';
  @override
  String get toGoOut => 'Sair';
  @override
  String get addPublication => 'Adicionar arquivos';
  @override
  String get address => 'Endereço';
  @override
  String get shepherd => 'Pastor responsável';
  @override
  String get baseLabel => 'Base';
  @override
  String get changePassword => 'Alterar senha';
  @override
  String get dateBirth => 'Data de Nascimento';
  @override
  String get loginRequired => 'Login necessário';
  @override
  String get needToLogin => ' Você precisa fazer login';
  @override
  String get loginRequiredSubtitle =>
      'Para visualizar essa funcionalidade, é preciso fazer login. Clique no botão abaixo e aproveite para ter acesso a todos os recursos!';
  @override
  String get searchMission => 'Busca de missões';
  @override
  String get toDoLogin => 'Fazer login';
  @override
  String get findBase => 'Encontre uma base';
  @override
  String get addAdmin => 'Adicionar admin';
  @override
  String get removeAdmin => 'Remover admin';
  @override
  String get fileSending => 'Envio de arquivo';
  @override
  String get uploadPhoto => 'Carregue a sua foto aqui';
  @override
  String get camera => 'Câmera';
  @override
  String get gallery => 'Galeria';
  @override
  String get basicInformation => 'Informações básicas';
  @override
  String get contentType => 'Tipo de conteúdo';
  @override
  String get publicationContent => 'Conteúdo da publicação';
  @override
  String get attachPhotosToPost => 'Anexar fotos para a publicação';
  @override
  String get photosAllowed => 'São permitidas até 5 fotos para a publicação.';
  @override
  String get femaleSex => 'Feminino';
  @override
  String get maleSex => 'Masculino';
  @override
  String get titlePost => 'Título';
  @override
  String get subtitlePost => 'Subtítulo (se tiver)';
  @override
  String get descriptionPost => 'Coloque o texto do conteúdo';
  @override
  String get publishedContent => 'Conteúdo publicado';
  @override
  String get publishedContentDescription =>
      'Seu conteúdo foi publicado com sucesso. Acesse ele!';
  @override
  String get viewContent => 'Ver conteúdo';
  @override
  String get addTags => 'Coloque as hashtags do conteúdo';
  @override
  String get typeLink => 'Link externo (site, vídeo, podcast)';
  @override
  String get typePDF => 'Arquivo PDF';
  @override
  String get typeInternText => 'Texto Interno';
  @override
  String get selectTypePost => 'Selecione o tipo de conteúdo';
  @override
  String get searchMembers => 'Encontre um membro';
  @override
  String get changeNameBase => 'Alterar nome da base';
  @override
  String get editBase => 'Editar';
  @override
  String get addAdminUser => 'Admin adicionado ao usuário';
  @override
  String get selectDate => 'Selecione a data';
  @override
  String get searchDate => 'Digite a data';
  @override
  String get select => 'Selecionar';
  @override
  String get dateInitial => 'Data inicial';
  @override
  String get dateFinal => 'Data final';
  @override
  String get statusConclued => 'Concluídas';
  @override
  String get statusPending => 'Envio pendente';
  @override
  String get detailsLabel => 'Detalhes';
  @override
  String get okLabel => 'Ok';
  @override
  String get registrationSuccessful => 'Cadastro realizado com sucesso';
  @override
  String get registrationCompletedSuccessfully =>
      'Seu cadastro foi finalizado com sucesso. Agora, você pode fazer login para ter acesso ao app.';
  @override
  String get errorSaveTitleAlert => 'Erro ao salvar alterações';
  @override
  String get errorSaveDescriptionAlert =>
      'Houve algum erro ao salvar suas alterações. Por favor, tente novamente.';
  @override
  String get dataLastDay => 'Último dia';
  @override
  String get dataLastSevenDays => 'Últimos 7 dias';
  @override
  String get dataLastFourteenDays => 'Últimos 14 dias';
  @override
  String get dataLastThirtyDays => 'Últimos 30 dias';
  @override
  String get dataPersonalized => 'Data personalizada';
  @override
  String get surname => 'Sobrenome';
  @override
  String get whatNameRegister => 'Qual seu nome?';
  @override
  String get subtitleRegister => 'Olá Weloz, vamos no conhecer melhor?';

  //ONBOARDING
  @override
  String get sendPackageFastTitle => 'Envie sua\nencomenda em tempo recorde';
  @override
  String get descriptionForms =>
      'Este formulário é uma ferramenta simples e eficiente que permite coletar informações';
  @override
  String get receiveWithoutBureaucracyTitle => 'Receba sem burocracia';
  @override
  String get receiveWithoutBureaucracySubtitle =>
      'Receba seus pacotes sem\ncomplicações, com acompanhamento\nem tempo real.';
  @override
  String get earnMoneyDrivingTitle => 'Ganhe dinheiro dirigindo';
  @override
  String get earnMoneyDrivingSubtitle =>
      'Ganhe dinheiro no seu tempo livre\ndirigindo com flexibilidade e suporte\ntotal.';

  //LOGIN
  @override
  String get welcomeUser => 'Olá, Weloz!';
  @override
  String get welcomeJourney => 'Sua jornada conosco está começando.\n';
  @override
  String get loginPrompt =>
      'Entre com seu login e senha ou crie\numa conta para iniciar sua experiência.';
  @override
  String get termsConditions =>
      'Ao clicar em "Continuar", você concorda com nossos Termos e reconhece nossa ';
  @override
  String get termsUse => 'Termos de Uso';
  @override
  String get e => 'e';
  @override
  String get privacyPolicy => 'Política de Privacidade.';
  @override
  String get loginCredentials => 'Se conecte com a ADRA Digital!';
  @override
  String get welcomeBack => 'Bem-vindo';
  @override
  String get cpfOrEmail => 'CPF ou e-mail';
  @override
  String get registerItem => 'Cadastrar item';
  @override
  String get descriptionLabel => 'Descrição';
  @override
  String get saveItem => 'Salvar item';
  @override
  String get estimatedWeight => 'Peso estimado (Kg):';
  @override
  String get whereGoing => 'Vai pra onde?';
  @override
  String get appName => 'Adra';
  @override
  String get recommendationsLabel => 'Recomendações';
  @override
  String get mySubmissions => 'Meus Envios';
  @override
  String get myOrders => 'Meus Pedidos';
  @override
  String get howUseApp => 'Como usar melhor o app';
  @override
  String get accountConfirmationLabel => 'Confirmação de conta';
  @override
  String get accountConfirmationSubtitle =>
      'Enviaremos um código por mensagem de texto ou e-mail, por onde deseja receber?';
  @override
  String get cellPhone => 'Celular';
  @override
  String get activityLabel => 'Atividades';
  @override
  String get activitySubtitle => 'Nenhum cadastro\n pendente';
  @override
  String get selectLabel => 'Selecione';
  @override
  String get resendLabel => 'Reenviar';
  @override
  String get listLabel => 'Lista';
  @override
  String get itemRegistrationLabel => 'Cadastro de Item';
  @override
  String get productName => 'Nome do produto';
  @override
  String get productType => 'Tipo';
  @override
  String get productPrice => 'Preço do produto';
  @override
  String get usedProductDescription =>
      'Se for um produto usado, utilize o preço aproximado do item.';
  @override
  String get exampleLabel => 'Ex: Peça de moto';
  @override
  String get detailsPrice => '0,00';
  @override
  String get finishLabel => 'Concluir';
  @override
  String get nfProductLabel => 'Nfs.monitor (12kb)';
  @override
  String get uploadNoteLabel => 'Carregar nota';
  @override
  String get declareContent => 'Declarar conteúdo';
  @override
  String get invoiceLabel => 'Nota Fiscal';
  @override
  String get documentationLabel => 'Documentação';
  @override
  String get sendInvoiceItem => 'Envie a nota fiscal do seu item.';
  @override
  String get chooseTagLabel => 'Escolha uma etiqueta';
  @override
  String get noRestrictionTag => 'Sem restrição';
  @override
  String get confidentialTag => 'Confidencial';
  @override
  String get fragileTag => 'Frágil';
  @override
  String get flammableTag => 'Inflamável';
  @override
  String get chemicalTag => 'Químico';
  @override
  String get perishableTag => 'Perecível';
  @override
  String get uploadPhotos => 'Carregar fotos';
  @override
  String get upPhotosAreAllowed => 'São permitidas até 5 fotos.';
  @override
  String get attachProductPhotos => 'Anexar fotos do produto';
  @override
  String get selectTag => 'Selecione uma etiqueta';
  @override
  String get itemHaveAnyRestrictions =>
      'O item transportado tem alguma restrição?';
  @override
  String get tagLabel => 'Etiquetas';
  @override
  String get centimetersLabel => 'cm';
  @override
  String get lengthLabel => 'Comprimento';
  @override
  String get widthLabel => 'Largura';
  @override
  String get heightLabel => 'Altura';
  @override
  String get packageLabel => 'Pacote';
  @override
  String get jumpButton => 'Pular';
  @override
  String get goToTrunk => 'Ir para o porta-malas';
  @override
  String get seeMoreProducts => 'Ver mais produtos';
  @override
  String get oneUnitLabel => '1 unidade';
  @override
  String get addedTrunk => 'Adicionado ao porta malas';
  @override
  String get noItemsRegistered =>
      'Ops, você ainda não tem itens\ncadastrados para envio.';
  @override
  String get placeInTheTrunk => 'Colocar no porta malas';
  @override
  String get submissionsLabel => 'Envios';
  @override
  String get savedItems => 'Itens Salvos ';
  @override
  String get shippedItems => 'Enviado com \nsucesso';
  @override
  String get yourTrunkEmpty => 'Ops, seu porta-malas está vazio.';
  @override
  String get addItems => 'Adicionar itens';
  @override
  String get closureLabel => 'encerramento';
  @override
  String get itemShipped => 'Item a ser enviado-Malas';
  @override
  String get closeTrunk => 'Fechar porta-malas';
  @override
  String get freightLabel => 'Frete';
  @override
  String get deliveryLabel => 'Entrega';
  @override
  String get withdrawalLabel => 'Retirada';
  @override
  String get all => 'Todos';
  @override
  String get category => 'Outras categorias';
  @override
  String get search => 'Buscar';
  @override
  String get filter => 'Filter';
  @override
  String get ordersEmptySubtitle =>
      'Ops, você ainda não realizou nenhum pedido.';
  @override
  String get waitingForRecipient => 'Aguardando envio';
  @override
  String get greatTrunkClosed => 'Ótimo,\nporta-malas\nfechado!';
  @override
  String get preparingOrder => 'Só um instante, estamos\npreparando o pedido.';
  @override
  String get chooseHowToPay => 'Escolha como pagar';
  @override
  String get paymentWithPix => 'Pague com pix';
  @override
  String get immediateApprovel => 'Aprovação imediata';
  @override
  String get newCreditCard => 'Novo cartão de crédito';

  @override
  String get orderStatus => 'Status do pedido';

  @override
  String get recipient => 'Destinatário';

  @override
  String get selectRecipient => 'Selecione o destinatário';

  @override
  String get payment => 'Pagamento';

  @override
  String get choosePaymentMethod => 'Escolha a forma de pagamento';

  @override
  String get payAndCompleted => 'Pagar e concluir';
  @override
  String get selectTheRecipient => 'Selecione o destinatário';
  @override
  String get receiveSubtitle =>
      'Encontre um destinatário já existente em nossa base de dados, ou convide para ser um weloz para receber a encomenda.';
  @override
  String get recipientNotDefined => 'Destinatário não definido';
  @override
  String get copyInviteLink => 'Copiar link de convite';
  @override
  String get whoWillReceiveIt => 'Quem irá receber?';
  @override
  String get searchTitle => 'Pesquise nome, e-mail, celular.';
  @override
  String get invite => 'Não encontrou? Convide!';
  @override
  String get inviteToAdra => 'Convidar para Weloz';
  @override
  String get newCard => 'Novo cartão';
  @override
  String get numberCard => 'Número do cartão';
  @override
  String get namePrintedOnCard => 'Nome impresso no cartão';
  @override
  String get maturity => 'vencimento';
  @override
  String get maturityHintText => 'MM/AA';
  @override
  String get securityCode => 'CCV';
  @override
  String get documentClient => 'Documento do titular';
  @override
  String get documentClientHintText => 'CPF ou CNPJ';
  @override
  String get saveCard => 'Salvar cartão';
  @override
  String get termsOfUseUpdate => 'Atualização Termos de Uso';
  @override
  String get firstAccess => 'Primeiro acesso';
  @override
  String get useCodeLabel => 'Usar código';
  @override
  String get continueWithMicrosoft => 'Continuar com Microsoft';
  @override
  String get continueWithGoogle => 'Continuar com Google';
  @override
  String get continueWithApple => 'Continuar com Apple';
  @override
  String get chooseSessionToEdit => 'Escolha sessão para editar';
  @override
  String get formsLabel => 'Formulários';
  @override
  String get timeLabel => 'Hora';
  @override
  String get multipleChoiceLabel => 'Múltipla Escolha';
  @override
  String get linearScaleLabel => 'Escala linear';
  @override
  String get uniqueSelectionLabel => 'Única Seleção';
  @override
  String get sessionLabel => 'Sessão';
  @override
  String get saveDraftLabel => 'Salvar rascunho';
  @override
  String get newRegister => 'Cadastrar novo';
  @override
  String get backToProjects => 'Voltar para formulários';
  @override
  String get messageSuccess => 'Mensagem de sucesso';
  @override
  String get messagePending =>
      'Quando você estiver online o cadastro será enviado automaticamente.';
  @override
  String get pendingIssues => 'Pendências';
  @override
  String get messagePendingIssues => 'Existem pendências nas seguintes sessões';
  @override
  String get openLabel => 'Em aberto';
  @override
  String get sentLabel => 'Enviados';
  @override
  String get messageEmptySend => 'Nenhum cadastro\n enviado';
  @override
  String get wrongLabel => 'Algo deu errado';
  @override
  String get viewRegistration => 'Ver cadastro';
  @override
  String get alreadyExistingLabel => 'Cadastro já existente';
  @override
  String get reuseRegistrationLabel => 'Reutilizar cadastro';
  @override
  String get versionLabel => 'Versão do App';
  @override
  String get messageEmpty =>
      'Você não possui formulários disponíveis no momento';

  // FILTERS
  @override
  String get filterAll => 'Todos';
  @override
  String get filterGroup => 'Grupo';
  @override
  String get filterProject => 'Projeto';
  @override
  String get filterForm => 'Formulário';
  @override
  String get filterBy => 'Filtrar por:';
  @override
  String get searchHint => 'Pesquisar formulários...';
  @override
  String get selectGroup => 'Selecione um grupo:';
  @override
  String get selectProject => 'Selecione um projeto:';
  @override
  String get selectForm => 'Selecione um formulário:';
  @override
  String get noFiltersAvailable => 'Nenhum filtro disponível';
}

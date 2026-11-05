// M04 Projets (M04b liste vide, M13 hors connexion, M14 chargement), M05 Projet (M05c suppression),
// M05b formulaire de projet (création et modification).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/api.dart';
import '../data/models.dart';
import '../format.dart';
import '../l10n/app_localizations.dart';
import '../state/data.dart';
import '../state/session.dart';
import '../ui/tokens.dart';
import '../ui/widgets.dart';
import 'common.dart';

String statusLabel(AppLocalizations t, ProjectStatus s) => switch (s) {
  ProjectStatus.active => t.commonStatusActive,
  ProjectStatus.inProgress => t.commonStatusInProgress,
  ProjectStatus.draft => t.commonStatusDraft,
};

LkBadgeTone statusTone(ProjectStatus s) => switch (s) {
  ProjectStatus.active => LkBadgeTone.success,
  ProjectStatus.inProgress => LkBadgeTone.warning,
  ProjectStatus.draft => LkBadgeTone.neutral,
};

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final projects = ref.watch(projectsProvider);
    final org = ref.watch(orgAccessProvider).value?.org;
    final atLimit = org?.atProjectLimit ?? false;
    final empty = projects.value?.isEmpty ?? false;
    Future<void> reload() async {
      ref.invalidate(orgAccessProvider);
      ref.invalidate(projectsProvider);
      await ref.read(projectsProvider.future).catchError((_) => <Project>[]);
    }

    return Scaffold(
      floatingActionButton: projects.hasValue && !empty
          ? SizedBox(
              width: 60,
              height: 60,
              child: FloatingActionButton(
                tooltip: t.projectsNew,
                elevation: 0,
                backgroundColor: atLimit ? LkColors.primary500.withValues(alpha: 0.45) : LkColors.primary500,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                onPressed: atLimit ? null : () => context.push('/projects/new'),
                child: const LkIcon('plus', color: Colors.white),
              ),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabHeader(t.projectsTitle, trailing: const OrgChip()),
          Expanded(
            child: switch (projects) {
              AsyncValue(hasValue: false, :final error?) => ErrorView(error: error, onRetry: reload),
              AsyncValue(value: final list?) => RefreshIndicator(
                onRefresh: reload,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 96),
                  children: [
                    if (projects.hasError) ...[OfflineBanner(onRetry: reload), const SizedBox(height: 16)],
                    if (atLimit && org != null) ...[
                      LkAlert(t.mobileProjectsLimit('${org.limits.projects}', '${org.usage.projects}')),
                      const SizedBox(height: 16),
                    ],
                    if (list.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: LkEmptyState(
                          illustration: 'projets-vide',
                          title: t.projectsEmptyTitle,
                          text: t.projectsEmptyText('${org?.limits.projects ?? 3}'),
                          action: LkButton(t.projectsEmptyCreate, onPressed: () => context.push('/projects/new')),
                        ),
                      ),
                    for (final p in list) ...[_ProjectCard(p), const SizedBox(height: 12)],
                  ],
                ),
              ),
              _ => const _ProjectsLoading(),
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard(this.project);
  final Project project;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return LkCard(
      onTap: () => context.push('/projects/${project.id}'),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: LkColors.primary50, borderRadius: BorderRadius.circular(10)),
            child: const Center(child: LkIcon('folder', color: LkColors.primary500)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name, style: LkText.cardTitle, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(t.commonMetaEdited(relativeTime(t, project.updatedAt)), style: LkText.meta),
              ],
            ),
          ),
          const SizedBox(width: 8),
          LkBadge(statusLabel(t, project.status), tone: statusTone(project.status)),
        ],
      ),
    );
  }
}

/// M14: grey cards while the list loads.
class _ProjectsLoading extends StatelessWidget {
  const _ProjectsLoading();

  @override
  Widget build(BuildContext context) => Semantics(
    label: context.t.commonLoading,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        for (final (title, meta) in const [(150.0, 90.0), (110.0, 120.0), (170.0, 80.0), (130.0, 100.0)]) ...[
          ExcludeSemantics(
            child: LkCard(
              child: Row(
                children: [
                  const LkSkeleton(width: 44, height: 44, radius: 10),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LkSkeleton(width: title, height: 14, radius: 7),
                      const SizedBox(height: 10),
                      LkSkeleton(width: meta, height: 10, radius: 5),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        ExcludeSemantics(
          child: Text(context.t.commonLoading, style: LkText.meta, textAlign: TextAlign.center),
        ),
      ],
    ),
  );
}

String historyText(AppLocalizations t, Activity a) {
  final name = a.actor?.name ?? 'LaunchKit';
  return switch (a.type) {
    'project_created' => t.projectsHistoryCreated(name),
    'project_status_changed' => t.projectsHistoryStatusChangedShort(
      statusLabel(t, ProjectStatus.parse(a.data['status'])),
    ),
    'project_description_changed' => t.projectsHistoryDescriptionChangedShort,
    _ => a.type,
  };
}

class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(projectProvider(id));
    return Scaffold(
      body: SafeArea(
        child: switch (detail) {
          AsyncValue(value: final d?) => _ProjectDetailView(d),
          AsyncValue(:final error?) => Column(
            children: [
              const BackHeader(''),
              Expanded(
                child: ErrorView(error: error, onRetry: () => ref.invalidate(projectProvider(id))),
              ),
            ],
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _ProjectDetailView extends ConsumerWidget {
  const _ProjectDetailView(this.detail);
  final ProjectDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final locale = Localizations.localeOf(context).languageCode;
    final p = detail.project;
    final me = ref.watch(sessionProvider.select((s) => s.user));
    final role = ref.watch(orgAccessProvider).value?.role ?? Role.member;
    final canDelete = role.isAdmin || p.createdBy == me?.id;
    Widget info(String label, String value) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: LkText.metaStrong),
        const SizedBox(height: 4),
        Text(value, style: LkText.bodyStrong),
      ],
    );

    return Column(
      children: [
        BackHeader(
          p.name,
          trailing: canDelete
              ? IconButton(
                  tooltip: t.commonActionDelete,
                  onPressed: () => _confirmDelete(context, ref, p),
                  icon: const LkIcon('ellipsis', color: LkColors.text),
                )
              : null,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: LkBadge(statusLabel(t, p.status), tone: statusTone(p.status)),
              ),
              const SizedBox(height: 20),
              Text(t.projectsDetailDescription, style: LkText.sectionTitle),
              const SizedBox(height: 8),
              Text(p.description.isEmpty ? '—' : p.description, style: LkText.body),
              const SizedBox(height: 24),
              LkCard(
                color: LkColors.surface,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    info(t.projectsDetailLead, p.leadName ?? '—'),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
                    info(t.projectsDetailDue, p.dueDate == null ? '—' : shortDate(p.dueDate!, locale)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
                    info(t.commonNavMembers, '${detail.members.length}'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(t.projectsDetailHistory, style: LkText.sectionTitle),
              const SizedBox(height: 14),
              for (final a in detail.history) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LkAvatar(name: a.actor?.name ?? 'LaunchKit', id: a.actor?.id ?? 'system', size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(historyText(t, a), style: LkText.label),
                          const SizedBox(height: 2),
                          Text(
                            relativeTime(t, a.createdAt),
                            style: LkText.caption.copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: LkButton(
            t.projectsDetailEditProject,
            kind: LkButtonKind.secondary,
            onPressed: () => context.push('/projects/${p.id}/edit'),
          ),
        ),
      ],
    );
  }

  /// M05c: confirmation in a bottom sheet.
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Project p) async {
    final t = context.t;
    final confirmed = await showLkSheet<bool>(
      context,
      (sheet) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text(t.projectsConfirmDeleteTitle(p.name), style: LkText.pageTitle)),
          const SizedBox(height: 10),
          Text(t.projectsConfirmDeleteText, style: LkText.body),
          const SizedBox(height: 24),
          LkButton(t.commonActionDelete, kind: LkButtonKind.danger, onPressed: () => Navigator.pop(sheet, true)),
          const SizedBox(height: 10),
          LkButton(t.commonActionCancel, kind: LkButtonKind.secondary, onPressed: () => Navigator.pop(sheet, false)),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(apiProvider).deleteProject(ref.read(sessionProvider).orgId!, p.id);
      if (!context.mounted) return;
      refreshOrgData(ref);
      showMessage(context, t.projectsToastDeleted);
      context.go('/projects');
    } on ApiError catch (e) {
      if (context.mounted) showMessage(context, errorText(t, e));
    }
  }
}

/// M05b: full-screen form, for a new project or to edit one.
class ProjectFormScreen extends ConsumerStatefulWidget {
  const ProjectFormScreen({super.key, this.id});
  final String? id;
  @override
  ConsumerState<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends ConsumerState<ProjectFormScreen> {
  final _name = TextEditingController(), _description = TextEditingController();
  ProjectStatus _status = ProjectStatus.draft;
  String? _leadId, _dueDate;
  bool _filled = false, _busy = false;
  ApiError? _error;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void _fill(Project p) {
    if (_filled) return;
    _filled = true;
    _name.text = p.name;
    _description.text = p.description;
    _status = p.status;
    _leadId = p.leadId;
    _dueDate = p.dueDate;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final current = _dueDate == null ? now : DateTime.parse(_dueDate!);
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(
        () => _dueDate = '${picked.year}-${'${picked.month}'.padLeft(2, '0')}-${'${picked.day}'.padLeft(2, '0')}',
      );
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
    });
    final input = ProjectInput(
      name: _name.text.trim(),
      description: _description.text.trim(),
      status: _status,
      leadId: _leadId,
      dueDate: _dueDate,
    );
    final api = ref.read(apiProvider);
    final org = ref.read(sessionProvider).orgId!;
    try {
      final t = context.t;
      final saved = widget.id == null
          ? await api.createProject(org, input)
          : await api.updateProject(org, widget.id!, input);
      if (!mounted) return;
      refreshOrgData(ref);
      if (widget.id != null) ref.invalidate(projectProvider(widget.id!));
      showMessage(context, widget.id == null ? t.projectsToastCreated(saved.name) : t.projectsToastSaved);
      context.go('/projects/${saved.id}');
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final locale = Localizations.localeOf(context).languageCode;
    if (widget.id != null) {
      final detail = ref.watch(projectProvider(widget.id!));
      if (detail.value case final d?) {
        _fill(d.project);
      } else {
        return Scaffold(
          body: SafeArea(
            child: detail.hasError
                ? ErrorView(error: detail.error!, onRetry: () => ref.invalidate(projectProvider(widget.id!)))
                : const Center(child: CircularProgressIndicator()),
          ),
        );
      }
    }
    final members = ref.watch(membersProvider).value?.members ?? const <Member>[];
    final error = _error;
    InputDecoration select() => const InputDecoration();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BackHeader(widget.id == null ? t.projectsNew : t.projectsDetailEditProject),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                children: [
                  if (error != null && error.errors.isEmpty) ...[
                    LkAlert(errorText(t, error), tone: LkTone.danger),
                    const SizedBox(height: 16),
                  ],
                  LkField(
                    label: t.projectsFormName,
                    controller: _name,
                    hint: 'Site vitrine',
                    help: t.projectsFormNameHelp,
                    error: error?.field('name'),
                  ),
                  const SizedBox(height: 16),
                  LkField(
                    label: t.projectsFormDescription,
                    controller: _description,
                    maxLines: 4,
                    hint: 'Refonte du site de l’agence…',
                    error: error?.field('description'),
                  ),
                  const SizedBox(height: 16),
                  Text(t.projectsDetailStatus, style: LkText.label),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<ProjectStatus>(
                    initialValue: _status,
                    decoration: select(),
                    style: LkText.input,
                    icon: const LkIcon('chevron-down'),
                    items: [
                      for (final s in ProjectStatus.values) DropdownMenuItem(value: s, child: Text(statusLabel(t, s))),
                    ],
                    onChanged: (s) => setState(() => _status = s ?? _status),
                  ),
                  const SizedBox(height: 16),
                  Text(t.projectsDetailLead, style: LkText.label),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String?>(
                    key: ValueKey(members.length),
                    initialValue: members.any((m) => m.id == _leadId) ? _leadId : null,
                    decoration: select(),
                    style: LkText.input,
                    icon: const LkIcon('chevron-down'),
                    hint: const Text('—'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('—')),
                      for (final m in members) DropdownMenuItem(value: m.id, child: Text(m.name)),
                    ],
                    onChanged: (id) => setState(() => _leadId = id),
                  ),
                  const SizedBox(height: 16),
                  Text(t.projectsDetailDue, style: LkText.label),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(10),
                    child: InputDecorator(
                      decoration: InputDecoration(errorText: error?.field('dueDate')),
                      child: Text(_dueDate == null ? '—' : shortDate(_dueDate!, locale), style: LkText.input),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: LkButton(
                widget.id == null ? t.projectsFormCreate : t.commonActionSave,
                onPressed: _submit,
                loading: _busy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

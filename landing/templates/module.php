<?php

$class = [];
$badge = [];
$title = [];

$layout = $theme->get('header.layout');

// Debug
if ($position == 'debug') {
    echo $module->content;
    return;
}

// Navbar Split
if ($position == 'navbar-split' && $module->type == 'menu') {
    echo $module->content;
    return;
}

if ($position == 'navbar') {

    $alignment = false;

    if ($index == 1 && preg_match('/(offcanvas|modal)-top-b/', $layout)) {
        $alignment = 'uk-margin-auto-top';
    } elseif ($index == 0 && preg_match('/(offcanvas|modal)-center-b/', $layout)) {
        $alignment = 'uk-margin-auto-vertical';
    } elseif ($index == 1 && $layout == 'stacked-left-b') {
        $alignment = 'uk-margin-auto-left';
    }

    if ($module->type == 'menu' && preg_match('/^(horizontal|stacked)/', $layout)) {

        if ($alignment) {
            echo "<div class=\"{$alignment}\">{$module->content}</div>";
        } else {
            echo $module->content;
        }

        return;

    }

    if (preg_match('/^(offcanvas|modal)-/', $layout)) {

        if ($alignment) {
            $class[] = $alignment;
        } elseif (!(preg_match('/(offcanvas|modal)-center-b/', $layout) && $index === 1)) {
            $class[] = 'uk-margin-top';
        }

    } else {

        if ($alignment) {
            $class[] = $alignment;
        }

        if ($module->type == 'search' && $theme->get('header.search_style') == 'modal' && preg_match('/^(horizontal|stacked)/', $layout)) {
            $class[] = 'uk-navbar-toggle';
        } else {
            $class[] = 'uk-navbar-item';
        }

    }

} elseif ($position == 'header' && preg_match('/^(offcanvas|modal|horizontal)/', $layout)) {

    if ($module->type == 'menu') {
        echo $module->content;
        return;
    }

    $class[] = 'uk-navbar-item';

} elseif (in_array($position, ['header', 'mobile', 'toolbar-right', 'toolbar-left'])) {

    $class[] = 'uk-panel';

} else {

    $class[] = $module->config->get('style') ? "uk-card uk-card-body uk-{$module->config->get('style')}" : 'uk-panel';

}

// Class
if ($cls = (array) $module->config->get('class')) {
    $class = array_merge($class, $cls);
}

// Visibility
if ($visibility = $module->config->get('visibility')) {
    $class[] = "uk-visible@{$visibility}";
}

// Grid + sidebar positions
if (!preg_match('/^(toolbar-left|toolbar-right|navbar|header|debug)$/', $position)) {

    // Title?
    if ($module->config->get('showtitle')) {

        $title['class'] = [];

        $title_element = $module->config->get('title_tag', 'h3');

        // Style?
        $title['class'][] = $module->config->get('title_style') ? "uk-{$module->config->get('title_style')}" : '';
        $title['class'][] = $module->config->get('style') && !$module->config->get('title_style') ? 'uk-card-title' : '';

        // Decoration?
        $title['class'][] = $module->config->get('title_decoration') ? "uk-heading-{$module->config->get('title_decoration')}" : '';

    }

    // Text alignment
    if ($module->config->get('text_align') && $module->config->get('text_align') != 'justify' && $module->config->get('text_align_breakpoint')) {
        $class[] = "uk-text-{$module->config->get('text_align')}@{$module->config->get('text_align_breakpoint')}";
        if ($module->config->get('text_align_fallback')) {
            $class[] = "uk-text-{$module->config->get('text_align_fallback')}";
        }
    } elseif ($module->config->get('text_align')) {
        $class[] = "uk-text-{$module->config->get('text_align')}";
    }

    // List
    if ($module->config->get('is_list')) {
        $class[] = 'tm-child-list';

        // List Style?
        if ($module->config->get('list_style')) {
            $class[] = "tm-child-list-{$module->config->get('list_style')}";
        }

        // Link Style?
        if ($module->config->get('link_style')) {
            $class[] = "uk-link-{$module->config->get('link_style')}";
        }
    }

}

// Grid positions
if (preg_match('/^(top|bottom|builder-\d+)$/', $position)) {

    // Max Width?
    if ($module->config->get('maxwidth')) {
        $class[] = "uk-width-{$module->config->get('maxwidth')}";

        // Center?
        if ($module->config->get('maxwidth_align')) {
            $class[] = 'uk-margin-auto';
        }

    }

}

?>

<div<?= $this->attrs(compact('class'), $module->attrs) ?>>

    <?php if ($title) : ?>
    <<?= $title_element ?><?= $this->attrs($title) ?>>

        <?php if ($module->config->get('title_decoration') == 'line') : ?>
            <span><?= $module->title ?></span>
        <?php else: ?>
            <?= $module->title ?>
        <?php endif ?>

    </<?= $title_element ?>>
    <?php endif ?>

    <?= $module->content ?>

</div>

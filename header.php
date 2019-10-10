<?php
/**
 * The header for our theme.
 *
 * This is the template that displays all of the <head> section and everything up until <body>
 *
 * @link https://developer.wordpress.org/themes/basics/template-files/#template-partials
 */

global $theme;

// Set view
if (is_home()|| is_category() || is_tag()) {
    $view = 'blog';
} elseif (is_singular('post')) {
    $view = 'post';
} else {
    $view = '';
}// Parameter shortcuts
$site  = $theme->get('site', []);
$blog_settings  = $theme->get('blog', []);
$post_settings  = $theme->get('post', []);

// Page
$attrs_page = [];
$attrs_page_container = [];
$attrs_image = [];
$attrs_media_overlay = [];

$attrs_page['class'][] = 'tm-page';

if ($site['layout'] == 'boxed') {

    $attrs_page['class'][] = $site['boxed.alignment'] ? 'uk-margin-auto' : '';
    $attrs_page['class'][] = $site['boxed.margin_top'] ? 'tm-page-margin-top' : '';
    $attrs_page['class'][] = $site['boxed.margin_bottom'] ? 'tm-page-margin-bottom' : '';
    $attrs_page_container['class'][] = 'tm-page-container uk-clearfix';

    // Image
    if ($site['boxed.media']) {

        $attrs_image = $theme->app['view']->bgImage($site['boxed.media'], [
            'width' => $site['image_width'],
            'height' => $site['image_height'],
            'size' => $site['image_size'],
            'position' => $site['image_position'],
            'visibility' => $site['image_visibility'],
            'blend_mode' => $site['media_blend_mode'],
            'background' => $site['media_background'],
            'effect' => $site['image_effect'],
            'parallax_bgx_start' => $site['image_parallax_bgx_start'],
            'parallax_bgy_start' => $site['image_parallax_bgy_start'],
            'parallax_bgx_end' => $site['image_parallax_bgx_end'],
            'parallax_bgy_end' => $site['image_parallax_bgy_end'],
            'parallax_easing' => $site['image_parallax_easing'],
            'parallax_breakpoint' => $site['image_parallax_breakpoint'],
            'parallax_target' => 'body',
        ]);

        if ($site['image_effect']) {
            $attrs_image['class'][] = 'uk-position-cover uk-position-fixed';
        } else {
            $attrs_page_container = array_merge_recursive($attrs_page_container, $attrs_image);
            $attrs_image = [];
        }

        // Overlay
        if ($site['media_overlay']) {
            $attrs_page_container['class'][] = 'uk-position-relative';
            $attrs_media_overlay['class'][] = 'uk-position-cover';
            $attrs_media_overlay['style'] = "background-color: {$site['media_overlay']};";
        }

    }

}

// Main section
$attrs_main_section = [];
$attrs_main_section['class'][] = 'tm-main uk-section uk-section-default';
$attrs_main_section['class'][] = $view == 'blog' && $blog_settings['padding'] ? "uk-section-{$blog_settings['padding']}" : '';
$attrs_main_section['class'][] = $view == 'post' && $post_settings['padding'] ? "uk-section-{$post_settings['padding']}" : '';
$attrs_main_section['class'][] = $view == 'post' && $post_settings['padding_remove'] ? 'uk-padding-remove-top' : '';

// Main container
$attrs_main_container = [];

if ($view !== 'post' || ($view == 'post' && $post_settings['width'] != 'none')) {
    $attrs_main_container['class'][] = 'uk-container';
    $attrs_main_container['class'][] = $view == 'blog' && $blog_settings['width'] ? "uk-container-{$blog_settings['width']}" : '';
    $attrs_main_container['class'][] = $view == 'post' && $post_settings['width'] ? "uk-container-{$post_settings['width']}" : '';
}?>
<!DOCTYPE html>
<html <?php language_attributes() ?>>
    <head>
        <meta charset="<?php bloginfo('charset') ?>">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="shortcut icon" href="<?= $theme->get('favicon') ?>">
        <link rel="apple-touch-icon-precomposed" href="<?= $theme->get('touchicon') ?>">
        <?php if (is_singular() && pings_open(get_queried_object())) : ?>
        <link rel="pingback" href="<?php bloginfo('pingback_url') ?>">
        <?php endif ?>
        <?php wp_head() ?>
    </head>
    <body <?php body_class($theme->get('body_class')->all()) ?>>
        <?php wp_body_open(); ?><?php if ($site['layout'] == 'boxed') : ?>
        <div<?= get_attrs($attrs_page_container) ?>>

            <?php if ($attrs_image) : ?>
            <div<?= get_attrs($attrs_image) ?>></div>
            <?php endif ?>

            <?php if ($attrs_media_overlay) : ?>
            <div class="uk-position-cover"<?= get_attrs($attrs_media_overlay) ?>></div>
            <?php endif ?>

        <?php endif ?>

        <?php if ($site['layout'] == 'boxed' && $site['boxed.header_outside']) : ?>
        <?= get_view('header') ?>
        <?php endif ?>

        <div<?= get_attrs($attrs_page) ?>>

            <?php if (!($site['layout'] == 'boxed' && $site['boxed.header_outside'])) : ?>
            <?= get_view('header') ?>
            <?php endif ?>

            <?php dynamic_sidebar("top:section") ?>

            <?php if (!$theme->get('builder')) : ?>

            <div id="tm-main" <?= get_attrs($attrs_main_section) ?> uk-height-viewport="expand: true">
                <div<?= get_attrs($attrs_main_container) ?>>

                    <?php if (is_active_sidebar('sidebar')) :
                            $sidebar = $theme->get('sidebar', []);
                            $grid = ['uk-grid'];
                            $grid[] = $sidebar['gutter'] ? "uk-grid-{$sidebar['gutter']}" : '';
                            $grid[] = $sidebar['divider'] ? 'uk-grid-divider' : '';
                    ?>

                    <div<?= get_attrs(['class' => $grid, 'uk-grid' => true]) ?>>
                        <div class="uk-width-expand@<?= $theme->get('sidebar.breakpoint') ?>">

                    <?php endif ?>

                            <?php if ($site['breadcrumbs']) : ?>
                            <div class="uk-margin-medium-bottom">
                                <?= get_section('breadcrumbs') ?>
                            </div>
                            <?php endif ?>

            <?php endif ?>
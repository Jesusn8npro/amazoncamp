<script>
  import { onMount, onDestroy, createEventDispatcher } from 'svelte';
  export let value = '';
  export let placeholder = 'Escribe el contenido del artículo...';
  export let readOnly = false;
  const dispatch = createEventDispatcher();

  let editorDiv;
  let quill;

  onMount(async () => {
    const QuillModule = await import('quill');
    await import('quill/dist/quill.snow.css');
    const Quill = QuillModule.default;

    quill = new Quill(editorDiv, {
      theme: 'snow',
      readOnly,
      placeholder,
      modules: {
        toolbar: [
          [{ header: [1, 2, 3, false] }],
          ['bold', 'italic', 'underline', 'strike'],
          [{ list: 'ordered' }, { list: 'bullet' }],
          ['blockquote', 'code-block'],
          ['link', 'image'],
          ['clean']
        ]
      }
    });
    quill.root.innerHTML = value || '';
    quill.on('text-change', () => {
      value = quill.root.innerHTML;
      dispatch('input', value);
    });
  });

  $: if (quill && quill.root.innerHTML !== value) {
    quill.root.innerHTML = value || '';
  }

  onDestroy(() => {
    if (quill) quill = null;
  });
</script>

<div bind:this={editorDiv} class="editor-quill" style="min-height:220px;"></div>

<style>
.editor-quill {
  background: #fff;
  border-radius: 8px;
  min-height: 220px;
  box-shadow: 0 2px 8px #0001;
  margin-bottom: 1rem;
}
.ql-toolbar {
  border-radius: 8px 8px 0 0;
}
.ql-container {
  border-radius: 0 0 8px 8px;
}
</style>

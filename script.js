/* eslint-env browser */
/* global $, bundle */

$(() => {
  $('body').on('click', '#accountSubmit', (e) => {
    e.preventDefault();
    $('#accountModal').modal('hide');
    bundle.Cryptex.addAccount($('#accountAddr').val(), $('#accountPk').val());
  });
});
function buyChange() { // eslint-disable-line no-unused-vars
  const amount = Number($('#buyAmount').val());
  const price = Number($('#buyPrice').val());
  const total = (amount * price).toFixed(3);
  $('#buyTotal').val(total);
}
function sellChange() { // eslint-disable-line no-unused-vars
  const amount = Number($('#sellAmount').val());
  const price = Number($('#sellPrice').val());
  const total = (amount * price).toFixed(3);
  $('#sellTotal').val(total);
}
$(() => {
  $('body').on('click', '#buySubmit', (e) => {
    e.preventDefault();
    bundle.Cryptex.order(
      'buy',
      $('#buyAmount').val(),
      $('#buyPrice').val(),
      $('#buyExpires').val(),
      false);
  });
});
$(() => {
  $('body').on('click', '#sellSubmit', (e) => {
    e.preventDefault();
    bundle.Cryptex.order(
      'sell',
      $('#sellAmount').val(),
      $('#sellPrice').val(),
      $('#sellExpires').val(),
      false);
  });
});
$('#buyCrossModal').on('show.bs.modal', (e) => {
  const order = $(e.relatedTarget).data('order');
  const amount = $(e.relatedTarget).data('amount');
  const desc = $(e.relatedTarget).data('desc');
  const token = $(e.relatedTarget).data('token');
  const base = $(e.relatedTarget).data('base');
  const price = $(e.relatedTarget).data('price');
  $('#buyCrossOrder').val(JSON.stringify(order.order));
  $('#buyCrossAmount').val(amount);
  $('#buyCrossDesc').html(desc);
  $('.buyCrossToken').html(token);
  $('.buyCrossBase').html(base);
  $('#buyCrossBaseAmount').val((amount * price).toFixed(3));
  $('#buyCrossFee').val((amount * price * 0.003).toFixed(6));
  $('#buyCrossBaseAmount').change(() => {
    $('#buyCrossAmount').val((Number($('#buyCrossBaseAmount').val()) / price).toFixed(3));
    $('#buyCrossFee').val(($('#buyCrossBaseAmount').val() * 0.003).toFixed(6));
  });
  $('#buyCrossAmount').change(() => {
    $('#buyCrossBaseAmount').val((Number($('#buyCrossAmount').val()) * price).toFixed(3));
    $('#buyCrossFee').val(($('#buyCrossBaseAmount').val() * 0.003).toFixed(6));
  });
   // live update
  $('#buyCrossBaseAmount').on('keyup', () => {
    $('#buyCrossBaseAmount').trigger('change');
  });
  $('#buyCrossAmount').on('keyup', () => {
    $('#buyCrossAmount').trigger('change');
  });
});
$('#sellCrossModal').on('show.bs.modal', (e) => {
  const order = $(e.relatedTarget).data('order');
  const amount = $(e.relatedTarget).data('amount');
  const desc = $(e.relatedTarget).data('desc');
  const token = $(e.relatedTarget).data('token');
  const base = $(e.relatedTarget).data('base');
  const price = $(e.relatedTarget).data('price');
  $('#sellCrossOrder').val(JSON.stringify(order.order));
  $('#sellCrossAmount').val(amount);
  $('#sellCrossDesc').html(desc);
  $('.sellCrossToken').html(token);
  $('.sellCrossBase').html(base);
  $('#sellCrossBaseAmount').val((amount * price).toFixed(3));
  $('#sellCrossFee').val(($('#sellCrossBaseAmount').val() * 0.003).toFixed(6));
  $('#sellCrossBaseAmount').change(() => {
    $('#sellCrossAmount').val((Number($('#sellCrossBaseAmount').val()) / price).toFixed(3));
    $('#sellCrossFee').val((Number($('#sellCrossBaseAmount').val()) * 0.003).toFixed(6));
  });
  $('#sellCrossAmount').change(() => {
    $('#sellCrossBaseAmount').val((Number($('#sellCrossAmount').val()) * price).toFixed(3));
    $('#sellCrossFee').val((Number($('#sellCrossBaseAmount').val()) * 0.003).toFixed(6));
  });
  // live update
  $('#sellCrossBaseAmount').on('keyup', () => {
    $('#sellCrossBaseAmount').trigger('change');
  });
  $('#sellCrossAmount').on('keyup', () => {
    $('#sellCrossAmount').trigger('change');
  });
});
$(() => {
  $('body').on('click', '#buyCrossSubmit', (e) => {
    e.preventDefault();
    $('#buyCrossModal').modal('hide');
    bundle.Cryptex.trade('buy', JSON.parse($('#buyCrossOrder').val()), $('#buyCrossAmount').val());
  });
});
$(() => {
  $('body').on('click', '#sellCrossSubmit', (e) => {
    e.preventDefault();
    $('#sellCrossModal').modal('hide');
    bundle.Cryptex.trade(
      'sell',
      JSON.parse($('#sellCrossOrder').val()),
      $('#sellCrossAmount').val());
  });
});
$(() => {
  $('body').on('click', '#otherTokenSubmit', (e) => {
    e.preventDefault();
    $('#otherTokenModal').modal('hide');
    bundle.Cryptex.selectToken(
      $('#otherTokenAddr').val(),
      $('#otherTokenName').val(),
      $('#otherTokenDecimals').val());
  });
});
$(() => {
  $('body').on('click', '#otherBaseSubmit', (e) => {
    e.preventDefault();
    $('#otherBaseModal').modal('hide');
    bundle.Cryptex.selectBase(
      $('#otherBaseAddr').val(),
      $('#otherBaseName').val(),
      $('#otherBaseDecimals').val());
  });
});
// $(() => {
  $('#chartPrice, #chartDepth').hover(
    function() {
      bundle.Cryptex.allowReloadCharts(false);
    }, function() {
      bundle.Cryptex.allowReloadCharts(true);
    }
  );
// });
function depositClick(addr) { // eslint-disable-line no-unused-vars
  bundle.Cryptex.deposit(addr, $(`#depositAmount${addr}`).val());
}
function withdrawClick(addr) { // eslint-disable-line no-unused-vars
  bundle.Cryptex.withdraw(addr, $(`#withdrawAmount${addr}`).val());
}
function transferClick(addr) { // eslint-disable-line no-unused-vars
  bundle.Cryptex.transfer(addr, $(`#transferAmount${addr}`).val(), $(`#transferTo${addr}`).val());
}
$(() => {});
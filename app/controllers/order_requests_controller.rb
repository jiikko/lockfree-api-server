# glb: Greatest lower  bound
# ghb: Greatest higher bound

class OrderRequestsController < ApplicationController
  class_attribute :paginatin_per_limit
  self.paginatin_per_limit = 100

  def index
    scope = OrderRequest.where(account_id: account_id).order(:id).limit(paginatin_per_limit)
    scope.where!('id > ?', glb) if glb
    scope.where!('id <= ?', ghb) if ghb
    next_url =
      if scope[-1] && ghb == scope[-1].id || scope.to_a.size < self.paginatin_per_limit
        nil
      else
        [ request.path_info,
          { ghb: ghb, glb: next_glb(scope), account_id: account_id }.to_param,
        ].join('?')
      end
    Rails.logger.info { "response ids: #{scope.map(&:id)}" }
    Rails.logger.info { "response count: #{scope.size}" }
    Rails.logger.info { "next_url: #{next_url || :なし}" }
    render(json: { order_requests: scope, next_url: next_url })
  end

  def create
    # TODO
  end

  private

  def since
    Time.parse(params[:since]) if params[:since].present?
  end

  def account_id
    params[:account_id]
  end

  def glb
    return @glb if @glb
    @glb =
      case
      when params[:glb]
        params[:glb]
      when since
        # explain SELECT `order_requests`.* FROM `order_requests` WHERE (account_id = '1' and created_at > '2010-12-31 15:00:00') order by created_at, id limit 1;
        # min(id)ではインデックス使った最適化が効かないのでorder by created_at, id limit 1のほうが早いはず(要検証)
        OrderRequest.where('account_id = ? and created_at > ?', account_id, since).minimum('id')
      else
        glb = OrderRequest.where(account_id: account_id).minimum('id')
        glb && glb - 1
      end
  end

  def next_glb(scope)
    # 次のglbが必ずしも+1ではない.他のユーザがいればその分離れるので次のglbをminimum関数で次ibを再取得する
    OrderRequest.where('account_id = ? and id > ?', account_id, scope.last.id).minimum('id') - 1
  end

  def ghb
    return @ghb if @ghb
    id = params[:ghb]
    return id.to_i if id
    @ghb = OrderRequest.where(account_id: account_id).maximum('id')
  end
end

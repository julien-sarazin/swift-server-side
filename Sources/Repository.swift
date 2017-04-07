public protocol Repository {
    associatedtype ModelType

    final func find(criteria: [String: Any]?, completion: (Result<[ModelType]>) -> (Void))
    final func findOne(criteria: [String: Any]?, completion: (Result<ModelType>) -> (Void))

    final func store(models: [ModelType], completion: (Result<[ModelType]>) -> (Void))
    final func storeOne(model: ModelType, completion: (Result<ModelType>) -> (Void))

    final func update(models: [ModelType], completion: (Result<[ModelType]>) -> (Void))
    final func updateOne(model: ModelType, completion: (Result<ModelType>) -> (Void))

    final func remove(models: [ModelType], completion: (Result<[ModelType]>) -> (Void))
}

open class AnyRepository<T> : Repository {

    public typealias ModelType = T

    private var repository: Any?

    private var _find: (([String: Any]?, (Result<[T]>) -> (Void)) -> Void)
    private var _findOne: (([String: Any]?, (Result<T>) -> (Void)) -> Void)

    private var _store: (([T], (Result<[T]>) -> (Void)) -> Void)
    private var _storeOne: ((T, (Result<T>) -> (Void)) -> Void)

    private var _update: (([T], (Result<[T]>) -> (Void)) -> Void)
    private var _updateOne: ((T, (Result<T>) -> (Void)) -> Void)

    private var _remove: (([T], (Result<[T]>) -> (Void)) -> Void)

    public required init<R: Repository>(_ repository: R) where R.ModelType == T {
        self.repository = repository
        self._find = repository.find
        self._findOne = repository.findOne
        self._store = repository.store
        self._storeOne = repository.storeOne
        self._update = repository.update
        self._updateOne = repository.updateOne

        self._remove = repository.remove
    }

    // MARK: Protocol implementation
    public func findOne(criteria: [String : Any]?, completion: (Result<T>) -> (Void)) {
        return self._findOne(criteria, completion)
    }

    public func find(criteria: [String : Any]?, completion: (Result<[T]>) -> (Void)) {
        return self._find(criteria, completion)
    }

    public func store(models: [T], completion: (Result<[T]>) -> (Void)) {
        return self._store(models, completion)
    }

    public func storeOne(model: T, completion: (Result<T>) -> (Void)) {
        return self._storeOne(model, completion)
    }

    public func update(models: [T], completion: (Result<[T]>) -> (Void)) {
        return self._update(models, completion)
    }

    public func updateOne(model: T, completion: (Result<T>) -> (Void)) {
        return self._updateOne(model, completion)
    }

    public func storeOrUpdate(models: [T], completion: (Result<[T]>) -> (Void)) {
        return self._storeOrUpdate(models, completion)
    }

    public func remove(models: [T], completion: (Result<[T]>) -> (Void)) {
        return self._remove(models, completion)
    }
}
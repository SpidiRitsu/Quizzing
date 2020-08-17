import {
  DefaultCrudRepository,
  repository,
  BelongsToAccessor,
} from '@loopback/repository';
import {
  AnswerHistory,
  AnswerHistoryRelations,
  QuizAttached,
  Questions,
  Users,
} from '../models';
import {MySqlDataSource} from '../datasources';
import {inject, Getter} from '@loopback/core';
import {QuizAttachedRepository} from './quiz-attached.repository';
import {QuestionsRepository} from './questions.repository';
import {UsersRepository} from './users.repository';

export class AnswerHistoryRepository extends DefaultCrudRepository<
  AnswerHistory,
  typeof AnswerHistory.prototype.id,
  AnswerHistoryRelations
> {
  public readonly quiz: BelongsToAccessor<
    QuizAttached,
    typeof AnswerHistory.prototype.id
  >;

  public readonly question: BelongsToAccessor<
    Questions,
    typeof AnswerHistory.prototype.id
  >;

  public readonly user: BelongsToAccessor<
    Users,
    typeof AnswerHistory.prototype.id
  >;

  constructor(
    @inject('datasources.MySQL') dataSource: MySqlDataSource,
    @repository.getter('QuizAttachedRepository')
    protected quizAttachedRepositoryGetter: Getter<QuizAttachedRepository>,
    @repository.getter('QuestionsRepository')
    protected questionsRepositoryGetter: Getter<QuestionsRepository>,
    @repository.getter('UsersRepository')
    protected usersRepositoryGetter: Getter<UsersRepository>,
  ) {
    super(AnswerHistory, dataSource);
    this.user = this.createBelongsToAccessorFor('user', usersRepositoryGetter);
    this.registerInclusionResolver('user', this.user.inclusionResolver);
    this.question = this.createBelongsToAccessorFor(
      'question',
      questionsRepositoryGetter,
    );
    this.registerInclusionResolver('question', this.question.inclusionResolver);
    this.quiz = this.createBelongsToAccessorFor(
      'quiz',
      quizAttachedRepositoryGetter,
    );
    this.registerInclusionResolver('quiz', this.quiz.inclusionResolver);
  }
}

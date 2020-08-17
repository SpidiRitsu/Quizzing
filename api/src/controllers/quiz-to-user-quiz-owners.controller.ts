import {repository} from '@loopback/repository';
import {param, get, getModelSchemaRef} from '@loopback/rest';
import {QuizToUser, QuizOwners} from '../models';
import {QuizToUserRepository} from '../repositories';

export class QuizToUserQuizOwnersController {
  constructor(
    @repository(QuizToUserRepository)
    public quizToUserRepository: QuizToUserRepository,
  ) {}

  @get('/quiz-to-users/{quizId}/quiz-owners', {
    responses: {
      '200': {
        description: 'QuizOwners belonging to QuizToUser',
        content: {
          'application/json': {
            schema: {type: 'array', items: getModelSchemaRef(QuizOwners)},
          },
        },
      },
    },
  })
  async getQuizOwners(
    @param.path.number('quizId') quizId: typeof QuizToUser.prototype.quizId,
  ): Promise<QuizOwners> {
    return this.quizToUserRepository.quiz(quizId);
  }
}

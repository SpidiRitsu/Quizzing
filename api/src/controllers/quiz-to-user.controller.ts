import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getModelSchemaRef,
  patch,
  put,
  del,
  requestBody,
} from '@loopback/rest';
import {QuizToUser} from '../models';
import {QuizToUserRepository} from '../repositories';

export class QuizToUserController {
  constructor(
    @repository(QuizToUserRepository)
    public quizToUserRepository: QuizToUserRepository,
  ) {}

  @post('/quiz-to-user', {
    responses: {
      '200': {
        description: 'QuizToUser model instance',
        content: {'application/json': {schema: getModelSchemaRef(QuizToUser)}},
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(QuizToUser, {
            title: 'NewQuizToUser',
            exclude: ['quizId'],
          }),
        },
      },
    })
    quizToUser: Omit<QuizToUser, 'quizId'>,
  ): Promise<QuizToUser> {
    return this.quizToUserRepository.create(quizToUser);
  }

  @get('/quiz-to-user/count', {
    responses: {
      '200': {
        description: 'QuizToUser model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.where(QuizToUser) where?: Where<QuizToUser>,
  ): Promise<Count> {
    return this.quizToUserRepository.count(where);
  }

  @get('/quiz-to-user', {
    responses: {
      '200': {
        description: 'Array of QuizToUser model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(QuizToUser, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  async find(
    @param.filter(QuizToUser) filter?: Filter<QuizToUser>,
  ): Promise<QuizToUser[]> {
    return this.quizToUserRepository.find(filter);
  }

  @patch('/quiz-to-user', {
    responses: {
      '200': {
        description: 'QuizToUser PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(QuizToUser, {partial: true}),
        },
      },
    })
    quizToUser: QuizToUser,
    @param.where(QuizToUser) where?: Where<QuizToUser>,
  ): Promise<Count> {
    return this.quizToUserRepository.updateAll(quizToUser, where);
  }

  @get('/quiz-to-user/{id}', {
    responses: {
      '200': {
        description: 'QuizToUser model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(QuizToUser, {includeRelations: true}),
          },
        },
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(QuizToUser, {exclude: 'where'})
    filter?: FilterExcludingWhere<QuizToUser>,
  ): Promise<QuizToUser> {
    return this.quizToUserRepository.findById(id, filter);
  }

  @patch('/quiz-to-user/{id}', {
    responses: {
      '204': {
        description: 'QuizToUser PATCH success',
      },
    },
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(QuizToUser, {partial: true}),
        },
      },
    })
    quizToUser: QuizToUser,
  ): Promise<void> {
    await this.quizToUserRepository.updateById(id, quizToUser);
  }

  @put('/quiz-to-user/{id}', {
    responses: {
      '204': {
        description: 'QuizToUser PUT success',
      },
    },
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() quizToUser: QuizToUser,
  ): Promise<void> {
    await this.quizToUserRepository.replaceById(id, quizToUser);
  }

  @del('/quiz-to-user/{id}', {
    responses: {
      '204': {
        description: 'QuizToUser DELETE success',
      },
    },
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.quizToUserRepository.deleteById(id);
  }
}
